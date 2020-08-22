//
//  NavigationMap.swift
//  Depromeet8th4
//
//  Created by Soso on 12/04/2020.
//  Copyright © 2020 Soso. All rights reserved.
//

import UIKit
import URLNavigator

struct NavigationMap {
    static func initialize(navigator: NavigatorType, viewController: UIViewController, provider: ServiceProviderType) {
        guard let navigationController = viewController as? UINavigationController else { return }
        navigator.register("honeypot://item/<id>") { (_, values, _) in
            guard let value = values["id"] as? String else { return nil }
            guard let id = Int(value) else { return nil }
            if let topViewController = navigationController.topViewController as? ItemViewController,
                topViewController.reactor?.currentState.itemID == id {
                return nil
            }
            return ItemViewController(reactor: .init(provider: provider, itemID: id))
        }
    }
}
