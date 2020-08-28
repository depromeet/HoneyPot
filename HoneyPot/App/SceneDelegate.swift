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

    func scene(_ scene: UIScene, willConnectTo _: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let date = Date().addingTimeInterval(0.7)
        RunLoop.current.run(until: date)

        let window = UIWindow(windowScene: windowScene)
        let provider = ServiceProvider()
        let mainViewController = HomeViewController(provider: provider)
        let navigationController = UINavigationController(rootViewController: mainViewController)
        navigationController.navigationBar.isHidden = true
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        self.window = window

        let navigator = Navigator()
        NavigationMap.initialize(navigator: navigator, viewController: navigationController, provider: provider)
        self.navigator = navigator

        if let url = connectionOptions.urlContexts.first?.url {
            if navigator.push(url) != nil {
                return
            }
        }
    }

    func scene(_: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            if navigator?.push(url) != nil {
                return
            }
        }
    }
}
