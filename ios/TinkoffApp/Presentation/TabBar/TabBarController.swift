//
//  TabBarController.swift
//  TinkoffApp
//
//  Created by Станислава on 11.03.2024.
//

import UIKit

class TabBarController: UITabBarController {
    private var mainScreenNavigationController: UINavigationController
    private var dashboardNavigationController: UINavigationController
    private var profileNavigationController: UINavigationController
    
    init(
        mainScreenNavigationController: UINavigationController,
        dashboardNavigationController: UINavigationController,
        profileNavigationController: UINavigationController
    ) {
        self.mainScreenNavigationController = mainScreenNavigationController
        self.dashboardNavigationController = dashboardNavigationController
        self.profileNavigationController = profileNavigationController
        
        super.init(nibName: nil, bundle: nil)
        
        setupTabBar()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTabBar() {
        tabBar.accessibilityIdentifier = "tabBar"
        tabBar.layer.borderWidth = 0.5
        tabBar.layer.masksToBounds = true
        tabBar.frame = CGRect(x: -1, y: 0, width: view.frame.width + 1, height: 84)
        
        tabBar.backgroundColor = .white
        tabBar.layer.borderColor = UIColor.systemGray4.cgColor
        tabBar.unselectedItemTintColor = .systemGray
        tabBar.tintColor = .systemBlue
        
        mainScreenNavigationController.tabBarItem = UITabBarItem(
            title: "Поездки",
            image: UIImage(systemName: "car"),
            tag: 0
        )
        
        dashboardNavigationController.tabBarItem = UITabBarItem(title: "Дашборд", image: UIImage(systemName: "speedometer"), tag: 1)
        
        profileNavigationController.tabBarItem = UITabBarItem(
            title: "Профиль",
            image: UIImage(systemName: "person.crop.circle"),
            tag: 2
        )
        profileNavigationController.tabBarItem.accessibilityIdentifier = "profileIcon"
        
        setViewControllers([
            mainScreenNavigationController,
            dashboardNavigationController,
            profileNavigationController
        ], animated: false)
    }
}
