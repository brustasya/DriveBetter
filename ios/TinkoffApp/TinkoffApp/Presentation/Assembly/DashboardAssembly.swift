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
        let presenter = DashboardPresenter(telemetryManager: LocationService())
        let dashboardVC = DashboardViewController(output: presenter)
        presenter.viewInput = dashboardVC
        
        return dashboardVC
    }
//    func makeConversationModule(with channelModel: ChannelModel, moduleOutput: ConversationModuleOutput) -> UIViewController {
//        let presenter = ConversationPresenter(
//            chatService: serviceAssembly.makeChatService(),
//            chatDataService: serviceAssembly.makeChatDataService(),
//            profileService: serviceAssembly.makeProfileService(),
//            channelModel: channelModel,
//            sseService: serviceAssembly.makeSSEService(),
//            mouleOutput: moduleOutput,
//            imageService: serviceAssembly.makeImageService()
//        )
//        let vc = ConversationsViewController(output: presenter)
//        presenter.viewInput = vc
//
//        return vc
//    }
}

