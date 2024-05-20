//
//  LocationService.swift
//  TinkoffApp
//
//  Created by Станислава on 12.03.2024.
//

import CoreLocation
import CoreMotion

final class LocationService: NSObject, LocationServiceProtocol {
    private let locationManager = CLLocationManager()
    private let motionManager = CMMotionActivityManager()
    private let telemetryService: TelemetryServiceProtocol
    
    private lazy var locationModels: [LocationModel] = []
    
    private var speedsSum = 0.0
    private var speedsCount = 0
    
    static let shared: LocationServiceProtocol = ServiceAssembly().makeLocationService()

    init(
        telemetryService: TelemetryServiceProtocol
    ) {
        self.telemetryService = telemetryService
        super.init()
        
        requestLocationPermission()
        locationManager.delegate = self
        locationManager.activityType = .automotiveNavigation
        locationManager.pausesLocationUpdatesAutomatically = false
        setActiveMode(true)
        
        currentSpeed.updateValue(0)
        maxSpeed.updateValue(0)
        averageSpeed.updateValue(0)

        motionManager.startActivityUpdates(to: .main, withHandler: { [weak self] activity in
            self?.setActiveMode(activity?.automotive ?? false)
        })
    }
    
    func requestLocationPermission() {
        locationManager.requestWhenInUseAuthorization()
    }

    func setActiveMode(_ value: Bool) {
        if value {
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            locationManager.distanceFilter = 0
            locationModels = []
            currentSpeed.updateValue(0)
            maxSpeed.updateValue(0)
            averageSpeed.updateValue(0)
        } else {
            locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
            locationManager.distanceFilter = CLLocationDistanceMax
            telemetryService.sendTripData(with: ServerTripModel(
                uuid: UserID.uuid,
                autoStart: true,
                autoFinish: true,
                points: locationModels
            )) { result in
                switch result {
                case .success(_):
                    print("Success trip send")
                case .failure(let failure):
                    print(failure)
                }

            }
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
    
    var currentSpeed: ObservableVariable<Double> = ObservableVariable(0.0)
    var maxSpeed: ObservableVariable<Double> = ObservableVariable(0.0)
    var averageSpeed: ObservableVariable<Double> = ObservableVariable(0.0)

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
                speed: Int(lastLocation.speed * 3.6),
                timestamp: Int(Date.now.timeIntervalSince1970),
                movementAngle: Int(lastLocation.courseAccuracy)
            )
            calculateSpeedMetrics(speed: speed)
            locationModels.append(locationModel)
        }
    }
}
