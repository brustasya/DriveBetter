from django.db import models


class LocationData(models.Model):
    uuid = models.CharField(max_length=100)
    ride_id = models.IntegerField()
    latitude = models.FloatField()
    longitude = models.FloatField()
    speed = models.FloatField()
    timestamp = models.IntegerField()
    movement_angle = models.FloatField()
    address_short = models.CharField(max_length=250, null=True)
    address_full = models.CharField(max_length=250, null=True)
    address_region_type_full = models.CharField(max_length=250, null=True)
    address_region = models.CharField(max_length=250, null=True)

    def __str__(self):
        return f'UUID: {self.uuid}, Latitude: {self.latitude}, Longitude: {self.longitude}, Speed: {self.speed}, Timestamp: {self.timestamp}'



default_address = dict()
default_address['address_short'] = 'г Москва'
default_address['address_full'] = 'г Москва'
default_address['address_region_type_full'] = 'город'
default_address['address_region'] = 'Москва'

class RideData(models.Model):
    ride_id = models.IntegerField()
    uuid = models.CharField(max_length=100)
    auto_start = models.BooleanField()
    auto_finish = models.BooleanField()
    max_speed = models.FloatField()
    min_speed = models.FloatField()
    light_nighttime = models.FloatField()
    nighttime = models.FloatField()
    detected_role = models.CharField(max_length=50)
    selected_role = models.CharField(max_length=50, null=True)
    weather = models.JSONField()
    dangerous_shifts = models.JSONField()
    dangerous_accelerations = models.JSONField()
    speeding = models.JSONField()
    address = models.JSONField(default=default_address)
    start_timestamp = models.IntegerField(default=1710335876)
    end_timestamp = models.IntegerField(default=1710429536)


class ProfileData(models.Model):
    uuid = models.CharField(max_length=100, unique=True)
    age = models.IntegerField(null=True)
    licence_number = models.CharField(max_length=100, null=True)
    sex = models.CharField(max_length=50, null=True)