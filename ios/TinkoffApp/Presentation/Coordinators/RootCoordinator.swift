//
//  RootCoordinator.swift
//  TinkoffApp
//
//  Created by Станислава on 08.02.2024.
//

import UIKit

final class RootCoordinator {
    private weak var window: UIWindow?
    
    private let mainScreenAssembly: MainScreenAssembly
    private let tripAssembly: TripAssembly
    private let profileAssembly: ProfileAssembly
    private let profileEditingAssembly: ProfileEditingAssembly
    private let dashboardAssembly: DashboardAssembly
    private let passengerTripAssembly: PassengerTripAssembly
    private let ratingAssembly: RatingAssembly
    
    private var mainScreenNavigationController = UINavigationController()
    private var profileNavigationController: UINavigationController = UINavigationController()
    private var tripViewController: UIViewController = UIViewController()
    private var profileEditingViewController: UIViewController = UIViewController()
    private var passengerTripViewController: UIViewController = UIViewController()
    private var ratingViewController: UIViewController = UIViewController()
    
    init(
        mainScreenAssembly: MainScreenAssembly,
        tripAssembly: TripAssembly,
        profileAssembly: ProfileAssembly,
        profileEditingAssembly: ProfileEditingAssembly,
        dashboardAssembly: DashboardAssembly,
        passengerTripAssembly: PassengerTripAssembly,
        ratingAssembly: RatingAssembly
    ) {
        self.mainScreenAssembly = mainScreenAssembly
        self.tripAssembly = tripAssembly
        self.profileAssembly = profileAssembly
        self.profileEditingAssembly = profileEditingAssembly
        self.dashboardAssembly = dashboardAssembly
        self.passengerTripAssembly = passengerTripAssembly
        self.ratingAssembly = ratingAssembly
    }
    
    func start(in window: UIWindow) {
        let mainScreenVC = mainScreenAssembly.makeMainScreenModule(moduleOutput: self)
        mainScreenNavigationController = UINavigationController(rootViewController: mainScreenVC)
        let profileRootVC = profileAssembly.makeProfileModule(moduleOutput: self)
        self.profileNavigationController = UINavigationController(rootViewController: profileRootVC)
        
        let tabBarController = TabBarController(
            mainScreenNavigationController: mainScreenNavigationController,
            dashboardNavigationController: UINavigationController(
                rootViewController: dashboardAssembly.makeDashboardModule()
            ),
            profileNavigationController: profileNavigationController
        )
        
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
        self.window = window
    }
    
    private func openTrip(with model: TripModel) {
        tripViewController = tripAssembly.makeTripModule(moduleOutput: self, model: model)
        mainScreenNavigationController.present(tripViewController, animated: true)
    }
    
    private func openPassengerTrip(with model: TripModel) {
        passengerTripViewController = passengerTripAssembly.makePassengerTripModule(moduleOutput: self, model: model)
        passengerTripViewController.modalPresentationStyle = .custom

        passengerTripViewController.transitioningDelegate = passengerTripViewController.self as? any UIViewControllerTransitioningDelegate
        mainScreenNavigationController.present(passengerTripViewController, animated: true, completion: nil)
    }
    
    private func closeTrip() {
        tripViewController.dismiss(animated: true)
    }
    
    private func closePassengerTrip() {
        passengerTripViewController.dismiss(animated: true)
    }
    
    private func openProfileEditing(
        with profileModel: UserProfileViewModel, isPhotoAdded: Bool, delegate: ProfileSaveDelegate?
    ) {
        profileEditingViewController = profileEditingAssembly.makeProfileEditingModule(
            moduleOutput: self, profileModel: profileModel, isPhotoAdded: isPhotoAdded, delegate: delegate
        )
        
        profileNavigationController.present(profileEditingViewController, animated: true, completion: nil)        
    }
    
    private func closeProfileEditing() {
        profileEditingViewController.dismiss(animated: true)
    }
    
    private func openRating() {
        ratingViewController = ratingAssembly.makeRatingModule(moduleOutput: self)
        profileNavigationController.pushViewController(ratingViewController, animated: true)
    }
    
    private func closeRating() {
        profileNavigationController.popViewController(animated: true)
    }
}

extension RootCoordinator: MainScreenModuleOutput {
    func moduleWantsToOpenTrip(with model: TripModel) {
        if model.isDriver {
            openTrip(with: model)
        } else {
            openPassengerTrip(with: model)
        }
    }
}

extension RootCoordinator: TripModuleOutput {
    func moduleWantsToCloseTrip() {
        closeTrip()
    }
}

extension RootCoordinator: ProfileModuleOutput {
    func moduleWantsToOpenRating() {
        openRating()
    }
    
    func moduleWantsToOpenProfileEditing(
        with profileModel: UserProfileViewModel,
        isPhotoAdded: Bool,
        delegate: ProfileSaveDelegate?
    ) {
        openProfileEditing(with: profileModel, isPhotoAdded: isPhotoAdded, delegate: delegate)
    }
}

extension RootCoordinator: ProfileEditingModuleOutput {
    func moduleWantsToCloseProfileEditing() {
        closeProfileEditing()
    }
}

extension RootCoordinator: RatingModuleOutput {
    func moduleWantsToCloseRating() {
        closeRating()
    }
}

extension RootCoordinator: PassengerTripModuleOutput {
    func moduleWantsToClosePassengerTrip() {
        closePassengerTrip()
    }
}
