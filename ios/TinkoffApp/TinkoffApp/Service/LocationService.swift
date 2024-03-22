//
//  LocationService.swift
//  TinkoffApp
//
//  Created by Станислава on 12.03.2024.
//

import CoreLocation
import CoreMotion

final class LocationService: NSObject {
    private let locationManager = CLLocationManager()
    private let motionManager = CMMotionActivityManager()
    
    private lazy var locationModels: [LocationModel] = []
    
    private var speedsSum = 0.0
    private var speedsCount = 0

    override init() {
        super.init()

        requestLocationPermission()
        locationManager.delegate = self
        locationManager.activityType = .automotiveNavigation
        locationManager.pausesLocationUpdatesAutomatically = false
        setActiveMode(true)

        motionManager.startActivityUpdates(to: .main, withHandler: { [weak self] activity in
            self?.setActiveMode(activity?.automotive ?? false)
        })
    }
    
    func requestLocationPermission() {
        locationManager.requestWhenInUseAuthorization()
    }

    func setActiveMode(_ value: Bool) {
        if value {
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.distanceFilter = 10
        } else {
            locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
            locationManager.distanceFilter = CLLocationDistanceMax
        }
    }
    
    func calculateSpeedMetrics(speed: Double) {
        guard speedsCount != 0 else {
            speedsCount += 1
            return
        }
        currentSpeed.updateValue(speed)
        if speed > maxSpeed.value {
            maxSpeed.updateValue(speed)
        }
        speedsCount += 1
        speedsSum += speed
        averageSpeed.updateValue(speedsSum / Double(speedsCount))
        
    }
    
    public func configure(desiredAccuracy: CLLocationAccuracy, distanceFilter:  CLLocationDistance) {
        locationManager.desiredAccuracy = desiredAccuracy
      //  locationManager.distanceFilter = distanceFilter
    }
    
    public var currentSpeed: ObservableVariable<Double> = ObservableVariable(0.0)
    public var maxSpeed: ObservableVariable<Double> = ObservableVariable(0.0)
    public var averageSpeed: ObservableVariable<Double> = ObservableVariable(0.0)

}

extension LocationService: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse:
            locationManager.allowsBackgroundLocationUpdates = false
            locationManager.startUpdatingLocation()
            self.locationManager.requestAlwaysAuthorization()
        case .authorizedAlways:
            locationManager.allowsBackgroundLocationUpdates = true
            locationManager.startUpdatingLocation()
            locationManager.startMonitoringSignificantLocationChanges()
        default:
            locationManager.stopUpdatingLocation()
            locationManager.stopMonitoringSignificantLocationChanges()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let lastLocation = locations.last {
            let speed = lastLocation.speed * 3.6
            let locationModel = LocationModel(
                latitude: lastLocation.coordinate.latitude,
                longitude: lastLocation.coordinate.longitude,
                speed: lastLocation.speed * 3.6,
                timestamp: Date.now
            )
            calculateSpeedMetrics(speed: speed)
           // print(locationModel)
            locationModels.append(locationModel)
        }
    }
}
