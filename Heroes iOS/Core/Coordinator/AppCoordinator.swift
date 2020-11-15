//
//  AppCoordinator.swift
//  Daniel Carera
//
//  Created by Daniel Cabrera on 11/05/2020.
//  Copyright © Daniel Cabrera. All rights reserved.
//

import UIKit

final class AppCoordinator: Coordinator {
    private let window: UIWindow
    private let navigationController = UINavigationController()
    init(window: UIWindow) {
        self.window = window
    }
    override func start() {
        let coordinator = HeroesFlowCoordinator(navigationController: navigationController)
        add(child: coordinator)
        coordinator.start()
        window.rootViewController = navigationController
        window.backgroundColor = .white
        window.makeKeyAndVisible()
    }
}
