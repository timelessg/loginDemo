//
//  LoginViewModel.swift
//  Demo
//
//  Created by 郭锐 on 2016/12/18.
//  Copyright © 2016年 郭锐. All rights reserved.
//

import UIKit
import RxSwift

class LoginViewModel: NSObject {
    let validatePhoneNum: Observable<Bool>
    let validateCode: Observable<Bool>
    let signedIn: Observable<Bool>
    let loginEnble: Observable<Bool>
    
    init(input: (
        phoneNum: Observable<String>,
        code: Observable<String>,
        loginTap: Observable<Void>
        )
        ) {
        
        
        validatePhoneNum = input.phoneNum.map({ (string:String) -> Bool in
            return string.characters.count > 0 && string.characters.count <= 11
        }).shareReplay(1)
        
        validateCode = input.code.map({ (string:String) -> Bool in
            return string.characters.count > 0
        }).shareReplay(1)
        
        loginEnble = Observable.combineLatest(self.validatePhoneNum,self.validateCode){ ($0,$1) }.shareReplay(1).map({ (x, y) -> Bool in
            return x && y
        }).shareReplay(1)

        let phoneAndCode = Observable.combineLatest(input.phoneNum,input.code){ ($0, $1) }.shareReplay(1)

        
        signedIn = input.loginTap
            .withLatestFrom(phoneAndCode)
            .flatMapLatest{ (x, y) in
                return NetworkClient().send(LoginAPI.Login(mobile: x, auth_code: y)).map({ (x) -> Bool in
                    return true
                }).catchErrorJustReturn(false)
        }
    }
}
