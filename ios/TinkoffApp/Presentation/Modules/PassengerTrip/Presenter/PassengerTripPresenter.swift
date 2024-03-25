//
//  PassengerTripPresenter.swift
//  TinkoffApp
//
//  Created by Станислава on 17.03.2024.
//

import Foundation

final class PassengerTripPresenter {
    weak var viewInput: PassengerTripViewInput?
    weak var moduleOutput: PassengerTripModuleOutput?
    
    private let telemetryService: TelemetryServiceProtocol
    private let tripModel: TripModel

    init(
        moduleOutput: PassengerTripModuleOutput,
        telemetryService: TelemetryServiceProtocol,
        tripModel: TripModel
    ) {
        self.moduleOutput = moduleOutput
        self.telemetryService = telemetryService
        self.tripModel = tripModel
    }
    
    private func changeRole() {
        telemetryService.changeRole(with: ChangeRoleModel(
            uuid: UserID.uuid,
            rideId: tripModel.rideID,
            selectedRole: Role.driver.rawValue
        )) { result in
            switch result {
            case .success(_):
                print("Change role success")
            case .failure(let failure):
                print(failure)
            }
        }
    }
}

extension PassengerTripPresenter: PassengerTripViewOutput {
    func changeRoleButtonTapped() {
        changeRole()
    }
    
    func viewIsReady() {
        viewInput?.setupTrip(tripModel: tripModel)
    }
    
    func closeButtonTapped() {
        moduleOutput?.moduleWantsToClosePassengerTrip()
    }
}
