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
        let presenter = MainScreenPresenter(moduleOutput: moduleOutput)
        let mainScreenVC = MainScreenViewController(output: presenter)
        presenter.viewInput = mainScreenVC
        
        return mainScreenVC
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

