//
//  LoginViewController.swift
//  PostList
//
//  Created by Pawan Kumar Dhawan on 14/08/24.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit

class LoginViewController : UIViewController {
    
    //Create textfield
    lazy var textFieldEmail:UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Email"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .emailAddress
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var textFieldPassword :UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Password"
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var btnLogin : UIButton = {
       let btn = UIButton()
        btn.setTitle("Login", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.setTitleColor(UIColor.white.withAlphaComponent(0.3), for: .highlighted)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(onTapBtnLogin), for: .touchUpInside)
        return btn
    }()
    
    var bag = DisposeBag()
    private let viewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        createObservables()
    }
    
    private func setupUI() {
        self.view.backgroundColor = .white
        self.view.addSubview(textFieldEmail)
        self.view.addSubview(textFieldPassword)
        self.view.addSubview(btnLogin)
        
        NSLayoutConstraint.activate([
            textFieldEmail.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor,constant: 20),
            textFieldEmail.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor,constant: -20),
            textFieldEmail.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor,constant: 40),
            textFieldPassword.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor,constant: 20),
            textFieldPassword.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor,constant: -20),
            textFieldPassword.topAnchor.constraint(equalTo: textFieldEmail.bottomAnchor,constant: 20),
            btnLogin.topAnchor.constraint(equalTo: textFieldPassword.bottomAnchor,constant: 40),
            btnLogin.widthAnchor.constraint(equalTo: textFieldEmail.widthAnchor),
            btnLogin.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            textFieldEmail.heightAnchor.constraint(equalToConstant: 40),
            textFieldPassword.heightAnchor.constraint(equalToConstant: 40),
            btnLogin.heightAnchor.constraint(equalToConstant: 40)
        ])
        
    }
    
    private func createObservables() {
        textFieldEmail.rx.text.map({$0 ?? ""}).bind(to: viewModel.email).disposed(by: bag)
        textFieldPassword.rx.text.map({$0 ?? ""}).bind(to: viewModel.password).disposed(by: bag)
        
        viewModel.isValidInput.bind(to: btnLogin.rx.isEnabled).disposed(by: bag)
        viewModel.isValidInput.subscribe( onNext: { [weak self] isValid in
            self?.btnLogin.backgroundColor = isValid ? .systemBlue :.lightGray
        }).disposed(by: bag)
    }
    
    
    @objc func onTapBtnLogin() {
        let tabBarController = UIStoryboard(name: Constants.Storyboard_Main, bundle: .main).instantiateViewController(identifier: "TabbarController")
        self.navigationController?.pushViewController(tabBarController, animated: true)
    }
    
}
