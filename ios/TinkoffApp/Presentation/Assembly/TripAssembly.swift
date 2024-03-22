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
    
    func makeTripModule(moduleOutput: TripModuleOutput) -> UIViewController {
        let presenter = TripPresenter(moduleOutput: moduleOutput)
        let tripVC = TripViewController(output: presenter)
        presenter.viewInput = tripVC
        
        return tripVC
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
