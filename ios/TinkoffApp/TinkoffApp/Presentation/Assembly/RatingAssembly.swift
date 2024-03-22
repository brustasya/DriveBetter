//
//  RatingAssembly.swift
//  TinkoffApp
//
//  Created by Станислава on 19.03.2024.
//

import Foundation

import UIKit

final class RatingAssembly {
    private let serviceAssembly: ServiceAssembly

    init(serviceAssembly: ServiceAssembly) {
        self.serviceAssembly = serviceAssembly
    }
    
    func makeRatingModule(moduleOutput: RatingModuleOutput) -> UIViewController {
        let presenter = RatingPresenter(moduleOutput: moduleOutput)
        let ratingVC = RatingViewController(output: presenter)
        presenter.viewInput = ratingVC
        
        return ratingVC
    }
}
