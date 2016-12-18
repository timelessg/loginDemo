//
//  LoginAPI.swift
//  Demo
//
//  Created by 郭锐 on 2016/12/18.
//  Copyright © 2016年 郭锐. All rights reserved.
//

import UIKit

enum LoginAPI {
    case Login(mobile: String?, auth_code: String?)
}

extension LoginAPI: Request {
    var path: String {
        switch self {
        case .Login(_):
            return "login.php"
        }
    }
    var parameters: [String: Any]? {
        switch self {
        case .Login(let mobile, let auth_code):
            return [
                "phone": mobile!,
                "code": auth_code!
            ]
        }
    }
}
