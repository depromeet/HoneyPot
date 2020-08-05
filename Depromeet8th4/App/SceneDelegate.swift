//
//  SceneDelegate.swift
//  Depromeet8th4
//
//  Created by Soso on 2020/07/15.
//  Copyright © 2020 Depromeet. All rights reserved.
//

import UIKit
import URLNavigator

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var navigator: NavigatorType?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowScene)
        let service = ServiceProvider()
        let mainViewController = MainViewController(service: service)
        let navigationController = UINavigationController(rootViewController: mainViewController)
        navigationController.setNavigationBarHidden(true, animated: false)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        self.window = window

        let navigator = Navigator()
        NavigationMap.initialize(navigator: navigator, viewController: navigationController, provider: service)
        self.navigator = navigator
    }
}
