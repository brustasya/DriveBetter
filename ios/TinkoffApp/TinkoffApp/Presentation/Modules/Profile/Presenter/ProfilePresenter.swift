//
//  ProfilePresenter.swift
//  TinkoffApp
//
//  Created by Станислава on 10.03.2024.
//

import Foundation
import Combine

// возраст, номер прав, пол

final class ProfilePresenter {
    weak var viewInput: ProfileViewInput?
    weak var moduleOutput: ProfileModuleOutput?
    private let profileService: UserProfileDataServiceProtocol
    private var profileModel: UserProfileViewModel?
    
    private lazy var cancellables = Set<AnyCancellable>()
    
    init(
        moduleOutput: ProfileModuleOutput,
        profileService: UserProfileDataServiceProtocol
    ) {
        self.moduleOutput = moduleOutput
        self.profileService = profileService
    }
    
    private func loadProfile() {
        profileService.loadUserProfile()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] userProfile in
                let profileModel = UserProfileViewModel(
                    userName: userProfile?.userName,
                    userDescription: userProfile?.userDescription,
                    userAvatar: userProfile?.userAvatar
                )
                
                self?.viewInput?.updateProfile(with: profileModel)
                self?.profileModel = profileModel
            }
            .store(in: &cancellables)
    }
}

extension ProfilePresenter: ProfileViewOutput {
    func viewIsReady() {
        loadProfile()
    }
    
    func addPhotoButtonTapped(with delegate: ProfileSaveDelegate?) {
        moduleOutput?.moduleWantsToOpenProfileEditing(
            with: profileModel ?? UserProfileViewModel(userName: "", userDescription: "", userAvatar: nil),
            isPhotoAdded: false,
            delegate: delegate
        )
    }
    
    func editButtonTapped(with delegate: ProfileSaveDelegate?) {
        moduleOutput?.moduleWantsToOpenProfileEditing(
            with: profileModel ?? UserProfileViewModel(userName: "", userDescription: "", userAvatar: nil),
            isPhotoAdded: true,
            delegate: delegate
        )
    }
    
    func update(with profileModel: UserProfileViewModel) {
        self.profileModel = profileModel
        viewInput?.updateProfile(with: profileModel)
    }
    
    func openRating() {
        moduleOutput?.moduleWantsToOpenRating()
    }
}
