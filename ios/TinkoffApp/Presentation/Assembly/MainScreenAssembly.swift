//
//  MainScreenAssembly.swift
//  TinkoffApp
//
//  Created by Станислава on 08.02.2024.
//

import UIKit

final class MainScreenAssembly {
    private let serviceAssembly: ServiceAssembly

    init(serviceAssembly: ServiceAssembly) {
        self.serviceAssembly = serviceAssembly
    }
    
    func makeMainScreenModule(moduleOutput: MainScreenModuleOutput) -> UIViewController {
        let presenter = MainScreenPresenter(
            moduleOutput: moduleOutput,
            telemetryServiceProtocol: serviceAssembly.makeTelemetryService()
        )
        let mainScreenVC = MainScreenViewController(output: presenter)
        presenter.viewInput = mainScreenVC
        
        return mainScreenVC
    }
}

