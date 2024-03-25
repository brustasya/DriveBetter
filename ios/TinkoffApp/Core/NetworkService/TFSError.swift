//
//  TFSError.swift
//  TinkoffApp
//
//  Created by Станислава on 22.03.2024.
//

import Foundation

enum TFSError: Error {
    case makeRequest
    case noData
    case redirect
    case badRequest
    case serverError
    case unexpectedStatus
}
