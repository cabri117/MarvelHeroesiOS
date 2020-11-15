//
//  SceneDelegate.swift
//  Heroes iOS
//
//  Created by Daniel Cabrera on 08/11/2020.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var appFlowCoordinator: AppCoordinator?
    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        guard let window = window else { return }
        appFlowCoordinator = AppCoordinator(window: window)
        appFlowCoordinator?.start()
    }
}
