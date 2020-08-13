//
//  Menu.swift
//  Depromeet8th4
//
//  Created by Soso on 2020/08/13.
//  Copyright © 2020 Depromeet. All rights reserved.
//

import UIKit

enum Menu {
    case invite, notice, customer, setting

    var title: String {
        switch self {
        case .invite: return "친구초대"
        case .notice: return "공지사항"
        case .customer: return "고객센터"
        case .setting: return "환경설정"
        }
    }

    var image: UIImage {
        switch self {
        case .invite: return #imageLiteral(resourceName: "icon_friend_w24h24")
        case .notice: return #imageLiteral(resourceName: "icon_sound_w24h24")
        case .customer: return #imageLiteral(resourceName: "icon_contact_w24h24")
        case .setting: return #imageLiteral(resourceName: "icon_setting_w24h24")
        }
    }
}
