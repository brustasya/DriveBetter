//
//  DashboardAssembly.swift
//  TinkoffApp
//
//  Created by Станислава on 10.03.2024.
//

import Foundation

import UIKit

final class DashboardAssembly {
    private let serviceAssembly: ServiceAssembly

    init(serviceAssembly: ServiceAssembly) {
        self.serviceAssembly = serviceAssembly
    }
    
    func makeDashboardModule() -> UIViewController {
        let presenter = DashboardPresenter()
        let dashboardVC = DashboardViewController(output: presenter)
        presenter.viewInput = dashboardVC
        
        return dashboardVC
    }
}

