//
//  MainScreenPresenter.swift
//  TinkoffApp
//
//  Created by Станислава on 08.02.2024.
//

import Foundation

final class MainScreenPresenter {
    weak var viewInput: MainScreenViewInput?
    weak var moduleOutput: MainScreenModuleOutput?
    
    private var trips: [TripModel] = [
        TripModel(date: Date.now, city: "Москва", rating: 7.7, isDriver: true),
        TripModel(date: Date.now, city: "Москва", rating: 9.9, isDriver: true),
        TripModel(date: Date.now, city: "Москва", rating: 1.2, isDriver: true),
        TripModel(date: Date.now, city: "Москва", rating: 10, isDriver: true)
    ]
    
    init(
        moduleOutput: MainScreenModuleOutput
//        productsService: ProductsServiceProtocol
    ) {
        self.moduleOutput = moduleOutput
//        self.productsService = productsService
    }
}

extension MainScreenPresenter: MainScreenViewOutput {
    func tripDidSelect(model: TripModel) {
        moduleOutput?.moduleWantsToOpenTrip(with: model)
    }
    
    
}

