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
    
    init(
        moduleOutput: PassengerTripModuleOutput
//        productsService: ProductsServiceProtocol
    ) {
        self.moduleOutput = moduleOutput
//        self.productsService = productsService
    }
}

extension PassengerTripPresenter: PassengerTripViewOutput {
    func closeButtonTapped() {
        moduleOutput?.moduleWantsToClosePassengerTrip()
    }
}
