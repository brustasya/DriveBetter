//
//  TripPresenter.swift
//  TinkoffApp
//
//  Created by Станислава on 08.02.2024.
//

import Foundation

final class TripPresenter {
    weak var viewInput: TripViewInput?
    weak var moduleOutput: TripModuleOutput?
    
    private let telemetryService: TelemetryServiceProtocol
    private let tripModel: TripModel

    init(
        moduleOutput: TripModuleOutput,
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
            selectedRole: Role.passenger.rawValue
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

extension TripPresenter: TripViewOutput {
    func changeRoleButtonTapped() {
        changeRole()
    }
    
    func closeButtonTapped() {
        moduleOutput?.moduleWantsToCloseTrip()
    }
    
    func viewIsReady() {
        viewInput?.setupTrip(model: tripModel)
    }
}
