from rest_framework import serializers
from .models import LocationData, ProfileData, RideData
from rest_framework.response import Response
from rest_framework import status


class LocationDataSerializer(serializers.ModelSerializer):
    class Meta:
        model = LocationData
        fields = ["uuid", "ride_id", "movement_angle", "latitude", "longitude", "speed", "timestamp"]


class LocationDataWithAddressSerializer(serializers.ModelSerializer):
    class Meta:
        model = LocationData
        fields = ["uuid", "address_short", "address_full", "address_region_type_full", "address_region", "ride_id", "movement_angle", "latitude", "longitude", "speed", "timestamp"]


class ProfileDataSerializer(serializers.ModelSerializer):
    class Meta:
        model = ProfileData
        fields = ["uuid", "age", "licence_number", "sex"]


class RideDataSerializer(serializers.ModelSerializer):
    class Meta:
        model = RideData
        fields = ["ride_id", "uuid", "detected_role", "selected_role", "max_speed", "min_speed", "speeding", "dangerous_accelerations", "dangerous_shifts", "light_nighttime", "nighttime", "weather", "auto_start", "auto_finish", "address", "start_timestamp", "end_timestamp"]
