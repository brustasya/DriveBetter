//
//  TripAssembly.swift
//  TinkoffApp
//
//  Created by Станислава on 08.02.2024.
//

import UIKit

final class TripAssembly {
    private let serviceAssembly: ServiceAssembly

    init(serviceAssembly: ServiceAssembly) {
        self.serviceAssembly = serviceAssembly
    }
    
    func makeTripModule(moduleOutput: TripModuleOutput, model: TripModel) -> UIViewController {
        let presenter = TripPresenter(
            moduleOutput: moduleOutput,
            telemetryService: serviceAssembly.makeTelemetryService(),
            tripModel: model
        )
        let tripVC = TripViewController(output: presenter)
        presenter.viewInput = tripVC
        
        return tripVC
    }
}
