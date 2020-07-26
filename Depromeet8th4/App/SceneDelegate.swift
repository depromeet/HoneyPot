//
//  SceneDelegate.swift
//  Depromeet8th4
//
//  Created by Soso on 2020/07/15.
//  Copyright © 2020 Depromeet. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

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
    }
}
