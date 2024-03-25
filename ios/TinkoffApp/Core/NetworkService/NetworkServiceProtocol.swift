//
//  NetworkServiceProtocol.swift
//  TinkoffApp
//
//  Created by Станислава on 22.03.2024.
//

import Foundation

protocol NetworkServiceProtocol: AnyObject {
    func sendRequest<T: Decodable>(_ request: URLRequest, completion: @escaping (Result<T, Error>) -> Void)
}
