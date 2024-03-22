//
//  ServiceAssembly.swift
//  TinkoffApp
//
//  Created by Станислава on 13.02.2024.
//

import Foundation

final class ServiceAssembly {
    func makeProfileService() -> UserProfileDataServiceProtocol {
        UserProfileDataService()
    }
}
