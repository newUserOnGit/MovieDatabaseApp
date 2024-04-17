//
//  RegistrationScreenViewController.swift
//  MovieBase
//
//  Created by Alexander on 15.04.2024.
//  Copyright © 2024 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import PinLayout

final class RegistrationScreenViewController: UIViewController {
    private let presenter: RegistrationScreenPresenterOutput
    
    init(presenter: RegistrationScreenPresenterOutput) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has been not impliminated")
    }
    
    let emailTextField: UITextField = {
        let emailTextField = UITextField()
        emailTextField.placeholder = "Email"
        emailTextField.borderStyle = .roundedRect
        emailTextField.frame = CGRect(x: 20, y: 100, width: UIScreen.main.bounds.width - 40, height: 40)
        return emailTextField
    }()
    let passwordTextField: UITextField = {
        let passwordTextField = UITextField()
        passwordTextField.placeholder = "Password"
        passwordTextField.isSecureTextEntry = true
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.frame = CGRect(x: 20, y: 100, width: UIScreen.main.bounds.width - 40, height: 40)
        return passwordTextField
    }()
    lazy var singInButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign in", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .blue
        button.frame = CGRect(x: 20, y: 100, width: 100, height: 40)
        button.addTarget(self, action: #selector(login), for: .touchUpInside)
        return button
    }()
    lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.frame = CGRect(x: 20, y: 100, width: 100, height: 40)
        button.addTarget(self, action: #selector(returnOnMain), for: .touchUpInside)
        return button
    }()
    let padding: CGFloat = 16
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubviews(emailTextField,
                         passwordTextField,
                         singInButton,
                         cancelButton)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sign up",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(showRegistration))
    }
    
    @objc
    func keyboardWillShow(notification: NSNotification) {
        if((notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= 40
            }
        }
    }
    
    @objc
    func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layout()
    }
}

extension RegistrationScreenViewController {
    func layout() {
        emailTextField.pin
            .center()
            .marginBottom(padding)
        
        passwordTextField.pin
            .below(of: emailTextField)
            .marginTop(padding)
        
        singInButton.pin
            .below(of: passwordTextField, aligned: .right)
            .margin(padding)
        
        cancelButton.pin
            .below(of: passwordTextField, aligned: .left)
            .margin(padding)
    }
}

extension RegistrationScreenViewController: RegistrationScreenPresenterInput {
    func showSuccessMessage() {
        let successAlert = UIAlertController(title: "Success", message: "You have successfully log in!", preferredStyle: .alert)
        successAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(successAlert, animated: true, completion: nil)
    }
    
    func showErrorMesage() {
        let errorAlert = UIAlertController(title: "Error", message: "Login failed. Please try again.", preferredStyle: .alert)
        errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(errorAlert, animated: true, completion: nil)
    }
    
    @objc
    func showRegistration() {
        let alertController = UIAlertController(title: "Registration", message: "Please, enter your Email and password", preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "Email"
            textField.keyboardType = .emailAddress
        }
        alertController.addTextField { textField in
            textField.placeholder = "Password"
            textField.isSecureTextEntry = true
        }
        
        let canselAction = UIAlertAction(title: "Cansel", style: .cancel, handler: nil)
        let registerAction = UIAlertAction(title: "Sign up", style: .default) { [weak self] _ in
            guard let emailTextField = alertController.textFields?.first, let passwordTextField = alertController.textFields?.last else
            { return }
            self?.presenter.registerUser(emailTextField.text ?? "", passwordTextField.text ?? "")
        }
        
        alertController.addAction(canselAction)
        alertController.addAction(registerAction)
        present(alertController, animated: true, completion: nil)
    }
    @objc
    func login() {
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }
        let isRegistered = presenter.loginUser(email, password)
        emailTextField.text = ""
        passwordTextField.text = ""
        if isRegistered{
           showSuccessMessage()
        } else {
            showErrorMesage()
        }
    }
    @objc
    func returnOnMain(){
        presenter.returnOnMain()
    }
}
