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
        navigator.register("honeypot://item/<id>") { (url, values, _) in
            print(navigationController)
            print(url, values)
            return nil
        }
    }
}
