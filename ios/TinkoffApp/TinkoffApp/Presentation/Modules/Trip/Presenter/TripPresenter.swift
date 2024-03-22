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
    
    init(
        moduleOutput: TripModuleOutput
//        productsService: ProductsServiceProtocol
    ) {
        self.moduleOutput = moduleOutput
//        self.productsService = productsService
    }
}

extension TripPresenter: TripViewOutput {
    func closeButtonTapped() {
        moduleOutput?.moduleWantsToCloseTrip()
    }
}
