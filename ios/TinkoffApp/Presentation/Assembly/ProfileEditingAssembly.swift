//
//  ProfileEdittingAssembly.swift
//  TinkoffApp
//
//  Created by Станислава on 10.03.2024.
//

import Foundation
import UIKit

final class ProfileEditingAssembly {
    private let serviceAssembly: ServiceAssembly

    init(serviceAssembly: ServiceAssembly) {
        self.serviceAssembly = serviceAssembly
    }
    
    func makeProfileEditingModule(
        moduleOutput: ProfileEditingModuleOutput,
        profileModel: UserProfileViewModel,
        isPhotoAdded: Bool,
        delegate: ProfileSaveDelegate?
    ) -> UIViewController {
        let presenter = ProfileEditingPresenter(
            profileService: serviceAssembly.makeProfileService(),
            moduleOutput: moduleOutput,
            profileModel: profileModel,
            isPhotoAdded: isPhotoAdded
        )
        let vc = ProfileEditingViewController(output: presenter)
        presenter.viewInput = vc
        presenter.delegate = delegate
        
        return vc
    }
}

