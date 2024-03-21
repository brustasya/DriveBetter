from .models import LocationData, RideData
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from datetime import datetime
from .serializers import LocationDataSerializer
from .serializers import ProfileDataSerializer
from .serializers import LocationDataWithAddressSerializer
from .serializers import RideDataSerializer
from dadata import Dadata
import openmeteo_requests
import requests_cache
import requests
import pandas as pd
from retry_requests import retry

token = "--dadata-token-here--"
dadata = Dadata(token)

cache_session = requests_cache.CachedSession('.cache', expire_after = 3600)
retry_session = retry(cache_session, retries = 5, backoff_factor = 0.2)
openmeteo = openmeteo_requests.Client(session = retry_session)
openmeteo_url = "https://api.open-meteo.com/v1/forecast"
openmeteo_format_string = "%Y-%m-%d"

max_city_speed = 60
max_speed_all = 90

# per second
max_angle_change_rate = 35
max_acceleration = 20

nightfall_delay = 5400  # 1.5 часа
full_day_time = 86400  # 24 часа


def get_address_for_point(lat, long):
        sugg = dadata.geolocate(name="address",
                                lat=lat,
                                lon=long)
        resp = dict()
        if len(sugg) > 0:
            resp['address_short'] = sugg[0]['value']
            resp['address_full'] = sugg[0]['unrestricted_value']
            resp['address_region_type_full'] = sugg[0]['data']['region_type_full']
            resp['address_region'] = sugg[0]['data']['region']
        return resp

class LocationDataView(APIView):

    def get(self, request, *args, **kwargs):
        '''
        List all the location points by uuid and potentially with timestamp limitations
        '''
        start_timestamp = 0
        if 'start_timestamp' in request.query_params:
            start_timestamp = request.query_params.get('start_timestamp')
        end_timestamp = 1000000000000000
        ride_id = None
        if 'end_timestamp' in request.query_params:
            end_timestamp = request.query_params.get('end_timestamp')
        if 'ride_id' in request.query_params:
            ride_id = request.query_params.get('ride_id')
        points = None
        if ride_id:
            points = LocationData.objects.filter(uuid=request.query_params.get('uuid'),
                                                 timestamp__gte=start_timestamp,
                                                 timestamp__lte=end_timestamp,
                                                 ride_id=ride_id)
        else:
            points = LocationData.objects.filter(uuid=request.query_params.get('uuid'),
                                                 timestamp__gte=start_timestamp,
                                                 timestamp__lte=end_timestamp)
        serializer = LocationDataSerializer(points, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)

class BatchLocationDataView(APIView):
    def post(self, request, *args, **kwargs):
        '''
        Create mulitple location points with given data
        '''
        points = request.data.get('points')
        uuid = request.data.get('uuid')
        auto_start = request.data.get('auto_start')
        auto_finish = request.data.get('auto_finish')
        if isinstance(points, list):
            for point in points:
                if isinstance(point, dict):
                    point['uuid'] = uuid
                    point['address_short'] = None
                    point['address_full'] = None
                    point['address_region_type_full'] = None
                    point['address_region'] = None
        if len(points) == 0:
            return Response({'error': 'there cannot be 0 points'}, status=status.HTTP_400_BAD_REQUEST)
        locationData = LocationData.objects.filter(uuid=uuid).order_by('-ride_id').first()
        ride_id = 0
        if locationData:
            ride_id = locationData.ride_id + 1
        for point in points:
            point['ride_id'] = ride_id
        serializer = LocationDataWithAddressSerializer(data=points, many=True)
        if not serializer.is_valid():
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

        ride = {
            'ride_id': ride_id,
            'uuid': uuid,
            'selected_role': None,
            'auto_start': auto_start,
            'auto_finish': auto_finish,
            'address': get_address_for_point(points[-1]['latitude'], points[-1]['longitude']),
            'start_timestamp': points[0]['timestamp'],
            'end_timestamp': points[-1]['timestamp']
        }

        ride['detected_role'] = 'водитель' if not (auto_start or auto_finish) else 'пассажир'
        speeds = [point['speed'] for point in points]
        ride['max_speed'] = max(speeds)
        ride['min_speed'] = min(speeds)

        points[-1].update(get_address_for_point(points[-1]['latitude'], points[-1]['longitude']))
        max_speed = 0
        if points[-1]['address_region_type_full'] == 'город':
            max_speed = max_city_speed
        else:
            max_speed = max_speed_all
        speeding = list()

        for i in range(0, len(points)):
            if points[i]['speed'] > max_speed:
                if 'short' not in points[i]:
                    points[i].update(get_address_for_point(points[i]['latitude'], points[i]['longitude']))

                tmp = {
                    'timestamp': points[i]['timestamp'],
                    'speed': points[i]['speed'],
                    'address': {
                        'short': points[i]['address_short'],
                        'full': points[i]['address_full'],
                        'region_type_full': points[i]['address_region_type_full'],
                        'region': points[i]['address_region']
                    }
                }
                speeding.append(tmp)
        ride['speeding'] = speeding

        dangerous_accelerations = list()
        dangerous_shifts = list()
        for i in range(1, len(points)):
            time_diff = points[i]['timestamp'] - points[i - 1]['timestamp']
            if time_diff == 0:
                continue
            angle_diff = points[i]['movement_angle'] - points[i - 1]['movement_angle']
            accel = (points[i]['speed'] - points[i - 1]['speed']) / time_diff
            angle_rate = angle_diff / time_diff
            if accel > max_acceleration:
                if 'short' not in points[i]:
                    points[i].update(get_address_for_point(points[i]['latitude'], points[i]['longitude']))
                tmp = {
                    'timestamp': points[i]['timestamp'],
                    'acceleration': accel,
                    'address': {
                        'short': points[i]['address_short'],
                        'full': points[i]['address_full'],
                        'region_type_full': points[i]['address_region_type_full'],
                        'region': points[i]['address_region']
                    }
                }
                dangerous_accelerations.append(tmp)
            if angle_rate > max_angle_change_rate:
                if 'short' not in points[i]:
                    points[i].update(get_address_for_point(points[i]['latitude'], points[i]['longitude']))
                tmp = {
                    'timestamp': points[i]['timestamp'],
                    'shift_angle': angle_diff,
                    'rate_of_angle_change': angle_rate,
                    'address': {
                        'short': points[i]['address_short'],
                        'full': points[i]['address_full'],
                        'region_type_full': points[i]['address_region_type_full'],
                        'region': points[i]['address_region']
                    }
                }
                dangerous_shifts.append(tmp)
        ride['dangerous_accelerations'] = dangerous_accelerations
        ride['dangerous_shifts'] = dangerous_shifts

        start_timestamp = points[0]['timestamp']
        end_timestamp = points[-1]['timestamp']
        start_date = datetime.fromtimestamp(start_timestamp)
        end_date = datetime.fromtimestamp(end_timestamp)

        params = {
            "latitude": points[-1]['latitude'],
            "longitude": points[-1]['longitude'],
            "hourly": ["weather_code", "visibility"],
            "timeformat": "unixtime",
            "timezone": "auto",
            "start_date": start_date.strftime(openmeteo_format_string),
            "end_date": end_date.strftime(openmeteo_format_string)
        }
        daily_req = f"https://api.open-meteo.com/v1/forecast?latitude={points[-1]['latitude']}&longitude={points[-1]['longitude']}&daily=sunrise,sunset&timeformat=unixtime&timezone=auto&start_date={start_date.strftime(openmeteo_format_string)}&end_date={end_date.strftime(openmeteo_format_string)}"
        meteo_resp = openmeteo.weather_api(openmeteo_url, params=params)[0]
        hourly = meteo_resp.Hourly()
        hourly_weather_code = hourly.Variables(0).ValuesAsNumpy()
        hourly_visibility = hourly.Variables(1).ValuesAsNumpy()

        hourly_data = {"date": pd.date_range(
            start=pd.to_datetime(hourly.Time(), unit="s", utc=True),
            end=pd.to_datetime(hourly.TimeEnd(), unit="s", utc=True),
            freq=pd.Timedelta(seconds=hourly.Interval()),
            inclusive="left"
        ), "weather_code": hourly_weather_code, "visibility": hourly_visibility}

        hourly_dataframe = pd.DataFrame(data=hourly_data)

        weather = list()
        for index, row in hourly_dataframe.iterrows():
            timestamp = int(datetime.timestamp(row['date']))
            if timestamp < start_timestamp:
                continue
            weather.append({'timestamp': timestamp,
                            'weather_code': int(row['weather_code']),
                            'visibility': row['visibility']})
            if timestamp > end_timestamp:
                break
        ride['weather'] = weather

        total_time = end_timestamp - start_timestamp
        night_time = 0
        lightnight_time = 0

        daily_json = requests.get(daily_req).json()
        daily = daily_json['daily']
        time = daily['time']
        sunrise = daily['sunrise']
        sunset = daily['sunset']
        for i in range(0, len(daily)):
            day_start = time[i]
            nightfall = sunset[i] - nightfall_delay
            # night time:
            if start_timestamp < sunrise[i]:
                night_time += min(sunrise[i], end_timestamp) - day_start
            if end_timestamp > sunset[i]:
                night_time += min(end_timestamp, day_start + full_day_time) - max(start_timestamp, sunset[i])
            # light night time:
            if end_timestamp > nightfall:
                lightnight_time += min(end_timestamp, sunset[i]) - max(start_timestamp, nightfall)
            # break condition:
            if end_timestamp <= day_start + full_day_time:
                break

        ride['light_nighttime'] = (lightnight_time * 100.0) / total_time
        ride['nighttime'] = (night_time * 100.0) / total_time
        serializer_ride = RideDataSerializer(data=ride)
        if not serializer_ride.is_valid():
            return Response(serializer_ride.errors, status=status.HTTP_400_BAD_REQUEST)
        serializer.save()
        serializer_ride.save()
        return Response({'ride_id': ride_id}, status=status.HTTP_201_CREATED)



class LocationCheckDataView(APIView):

    def post(self, request, *args, **kwargs):
        '''
        Create location point with given data
        '''
        latitude = request.data.get('latitude')
        longitude = request.data.get('longitude')
        if latitude and longitude:
            sugg = dadata.geolocate(name="address",
                                    lat=latitude,
                                    lon=longitude)
            address = dict()
            response = dict()
            if len(sugg) > 0:
                address['short'] = sugg[0]['value']
                address['full'] = sugg[0]['unrestricted_value']
                address['region_type_full'] = sugg[0]['region_type_full']
                address['region'] = sugg[0]['region']
                response['address'] = address
            return Response(response, status=status.HTTP_201_CREATED)
        return Response({}, status=status.HTTP_400_BAD_REQUEST)


class ProfileDataView(APIView):

    def post(self, request, *args, **kwargs):
        data = {
            'uuid': request.data.get('uuid'),
            'age': request.data.get('age'),
            'licence_number': request.data.get('licence_number'),
            'sex': request.data.get('sex')
        }
        serializer = ProfileDataSerializer(data=data)
        if serializer.is_valid():
            serializer.save()
            return Response({}, status=status.HTTP_200_OK)

        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class RideDataView(APIView):

    def get(self, request, *args, **kwargs):
        rides = RideData.objects.filter(uuid=request.query_params.get('uuid'))
        serializer = RideDataSerializer(rides, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)

    def put(self, request, *args, **kwargs):
        uuid = request.data.get('uuid')
        ride_id = request.data.get('ride_id')
        selected_role = request.data.get('selected_role')
        try:
            ride = RideData.objects.get(uuid=uuid, ride_id=ride_id)
        except RideData.DoesNotExist:
            return Response({}, status=status.HTTP_404_NOT_FOUND)
        ride.selected_role = selected_role
        ride.save()
        return Response({}, status=status.HTTP_200_OK)