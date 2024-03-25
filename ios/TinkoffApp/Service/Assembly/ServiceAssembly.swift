//
//  ServiceAssembly.swift
//  TinkoffApp
//
//  Created by Станислава on 13.02.2024.
//

import Foundation

final class ServiceAssembly {
    private let host = "34.155.177.3"
    private let port = 8000
    
    func makeProfileService() -> UserProfileDataServiceProtocol {
        UserProfileDataService()
    }
    
    func makeTelemetryService() -> TelemetryServiceProtocol {
        TelemetryService(
            networkService: NetworkService(),
            requestFactory: URLRequestFactory(host: host, port: port)
        )
    }
    
    func makeLocationService() -> LocationServiceProtocol {
        LocationService(telemetryService: makeTelemetryService())
    }
    
}
