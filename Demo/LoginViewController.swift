//
//  LoginViewController.swift
//  Demo
//
//  Created by 郭锐 on 2016/12/19.
//  Copyright © 2016年 郭锐. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class LoginViewController: UIViewController {
    let phoneTextField = UITextField.init(frame: CGRect.init(x: 0, y: 0, width: 200, height: 50))
    let codeTextField = UITextField.init(frame: CGRect.init(x: 0, y: 0, width: 200, height: 50))
    let loginButton = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 100, height: 50))
    
    let tipLabel = UILabel.init()
    
    var viewModel:LoginViewModel?
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        phoneTextField.center = CGPoint.init(x: view.center.x, y: 100)
        phoneTextField.placeholder = "请输入手机号码"
        view.addSubview(phoneTextField)
        
        codeTextField.center = CGPoint.init(x: view.center.x, y: 200)
        codeTextField.placeholder = "请输入验证码"
        view.addSubview(codeTextField)
        
        
        loginButton.center = CGPoint.init(x: view.center.x, y: 300)
        loginButton.setTitle("登陆", for: .normal)
        loginButton.setTitleColor(UIColor.black, for: .normal)
        loginButton.setTitleColor(UIColor.gray, for: .disabled)
        view.addSubview(loginButton)
        
        bindViewModel()
        
    }
    func bindViewModel() {
        viewModel = LoginViewModel.init(
            input: (
                phoneNum:self.phoneTextField.rx.text.orEmpty.asObservable(),
                code: self.codeTextField.rx.text.orEmpty.asObservable(),
                loginTap: self.loginButton.rx.tap.asObservable()
            )
        )
        
        viewModel?.loginEnble.subscribe(onNext: { [weak self] (x) in
            self?.loginButton.isEnabled = x
        }).addDisposableTo(disposeBag)
        
        viewModel?.signedIn.subscribe(onNext: {(x) in
            if x {
                print("登陆成功")
            }else{
                print("登陆失败")
            }
        }).addDisposableTo(disposeBag)

    }
}
