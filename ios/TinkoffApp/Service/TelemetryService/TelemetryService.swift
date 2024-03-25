//
//  TelemetryService.swift
//  TinkoffApp
//
//  Created by Станислава on 22.03.2024.
//

import Foundation

protocol TelemetryServiceProtocol {
    func getTrips(completion: @escaping (Result<[RideModel], Error>) -> Void)
    func sendTripData(with model: ServerTripModel, completion: @escaping (Result<[String: Int], Error>) -> Void)
    func changeRole(with model: ChangeRoleModel, completion: @escaping (Result<[String: String], Error>) -> Void)
    func createProile(with model: ServerProfileModel, completion: @escaping (Result<[String: String], Error>) -> Void)
}

class TelemetryService: TelemetryServiceProtocol {
    
    private let networkService: NetworkServiceProtocol
    private let requestFactory: URLRequestFactoryProtocol
    
    init(networkService: NetworkServiceProtocol,
         requestFactory: URLRequestFactoryProtocol) {
        self.networkService = networkService
        self.requestFactory = requestFactory
    }
    
    func getTrips(completion: @escaping (Result<[RideModel], Error>) -> Void) {
        do {
            let request = try requestFactory.getTripsRequest(uuid: UserID.uuid)
            networkService.sendRequest(request, completion: completion)
        } catch {
            completion(.failure(error))
        }
    }
    
    func sendTripData(with model: ServerTripModel, completion: @escaping (Result<[String: Int], Error>) -> Void) {
        do {
            let request = try requestFactory.sendTripDataRequest(with: model)
            networkService.sendRequest(request, completion: completion)
        } catch {
            completion(.failure(error))
        }
    }
    
    func changeRole(with model: ChangeRoleModel, completion: @escaping (Result<[String: String], Error>) -> Void) {
        do {
            let request = try requestFactory.changeStatusRequest(with: model)
            networkService.sendRequest(request, completion: completion)
        } catch {
            completion(.failure(error))
        }
    }
    
    func createProile(with model: ServerProfileModel, completion: @escaping (Result<[String: String], Error>) -> Void) {
        do {
            let request = try requestFactory.createProfileRequest(with: model)
            networkService.sendRequest(request, completion: completion)
        } catch {
            completion(.failure(error))
        }
    }
}

