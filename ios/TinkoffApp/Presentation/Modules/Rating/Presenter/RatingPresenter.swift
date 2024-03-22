//
//  RatingPresenter.swift
//  TinkoffApp
//
//  Created by Станислава on 19.03.2024.
//

import Foundation

final class RatingPresenter {
    weak var viewInput: RatingViewInput?
    weak var moduleOutput: RatingModuleOutput?
    
    init(
        moduleOutput: RatingModuleOutput
//        productsService: ProductsServiceProtocol
    ) {
        self.moduleOutput = moduleOutput
//        self.productsService = productsService
    }
}

extension RatingPresenter: RatingViewOutput {
    func closeRating() {
        moduleOutput?.moduleWantsToCloseRating()
    }
    
    
}

