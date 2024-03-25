//
//  ProfileAssembly.swift
//  TinkoffApp
//
//  Created by Станислава on 10.03.2024.
//

import Foundation
import UIKit

final class ProfileAssembly {
    private let serviceAssembly: ServiceAssembly

    init(serviceAssembly: ServiceAssembly) {
        self.serviceAssembly = serviceAssembly
    }
    
    func makeProfileModule(moduleOutput: ProfileModuleOutput) -> UIViewController {
        let presenter = ProfilePresenter(
            moduleOutput: moduleOutput,
            profileService: serviceAssembly.makeProfileService()
        )
        let profileVC = ProfileViewController(output: presenter)
        presenter.viewInput = profileVC
        
        return profileVC
    }
}

