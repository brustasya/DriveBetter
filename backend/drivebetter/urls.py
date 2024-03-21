from django.contrib import admin
from django.urls import path, include
from server import urls as api_urls

urlpatterns = [
    path('admin/', admin.site.urls),
    path('api-auth/', include('rest_framework.urls')),
    path('api/', include(api_urls)),
]
