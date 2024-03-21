from django.urls import path
from .views import (
    LocationDataView,
    BatchLocationDataView,
    LocationCheckDataView,
    ProfileDataView,
    RideDataView
)

urlpatterns = [
    path('location', LocationDataView.as_view()),
    path('location/check', LocationCheckDataView.as_view()),
    path('location/batch', BatchLocationDataView.as_view()),
    path('profile', ProfileDataView.as_view()),
    path('ride', RideDataView.as_view())
]