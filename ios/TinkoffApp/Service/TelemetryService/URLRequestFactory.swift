//
//  URLRequestFactory.swift
//  TinkoffApp
//
//  Created by Станислава on 22.03.2024.
//

import Foundation

protocol URLRequestFactoryProtocol {
    func getTripsRequest(uuid: String) throws -> URLRequest
    func sendTripDataRequest(with tripsModel: ServerTripModel) throws -> URLRequest
    func createProfileRequest(with profileModel: ServerProfileModel) throws -> URLRequest
    func changeStatusRequest(with changeRoleModel: ChangeRoleModel) throws -> URLRequest
}

final class URLRequestFactory: URLRequestFactoryProtocol {
    
    private let host: String
    private let port: Int
    
    init(host: String, port: Int) {
        self.host = host
        self.port = port
    }
    
    func getTripsRequest(uuid: String) throws -> URLRequest {
        guard let url = url(with: "/api/ride", query: "uuid=\(uuid)") else {
            throw TFSError.makeRequest
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        return request
    }
    
    func sendTripDataRequest(with tripsModel: ServerTripModel) throws -> URLRequest {
        guard let url = url(with: "/api/location/batch"),
              var request = makeRequest(with: tripsModel, url: url) else {
            throw TFSError.makeRequest
        }
        
        request.httpMethod = "POST"
        
        return request
    }
    
    func createProfileRequest(with profileModel: ServerProfileModel) throws -> URLRequest {
        guard let url = url(with: "/api/profile"),
              var request = makeRequest(with: profileModel, url: url) else {
            throw TFSError.makeRequest
        }
        
        request.httpMethod = "POST"
        
        return request
    }
    
    func changeStatusRequest(with changeRoleModel: ChangeRoleModel) throws -> URLRequest {
        guard let url = url(with: "/api/ride"),
              var request = makeRequest(with: changeRoleModel, url: url) else {
            throw TFSError.makeRequest
        }
        
        request.httpMethod = "PUT"
        
        return request
    }
}

private extension URLRequestFactory {
    private func url(with path: String, query: String? = nil) -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "http"
        urlComponents.host = host
        urlComponents.port = port
        urlComponents.path = path
        urlComponents.query = query
        
        guard let url = urlComponents.url else {
            return nil
        }
        
        return url
    }
    
    private func makeRequest<T: Codable>(with model: T, url: URL) -> URLRequest? {
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        guard let jsonData = try? JSONEncoder().encode(model) else {
            return nil
        }
        
        request.httpBody = jsonData
        
        return request
    }
}
