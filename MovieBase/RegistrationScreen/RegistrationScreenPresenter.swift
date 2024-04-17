//
//  RegistrationScreenPresenter.swift
//  MovieBase
//
//  Created by Alexander on 15.04.2024.
//  Copyright © 2024 ___ORGANIZATIONNAME___. All rights reserved.
//

protocol RegistrationScreenPresenterInput: AnyObject {
    func showRegistration()
    func showSuccessMessage()
    func showErrorMesage()
}
protocol RegistrationScreenPresenterOutput: AnyObject {
    func registerUser(_ emailUser: String, _ password: String)
    func loginUser(_ emailUser: String, _ password: String) -> Bool
    func returnOnMain()
}

final class RegistrationScreenPresenter: RegistrationScreenPresenterOutput {
    weak var input: RegistrationScreenPresenterInput?
    let router: RegistrationScreenRouter
    let interactor: RegistrationScreenInteractor

    init(_ router: RegistrationScreenRouter, _ interactor: RegistrationScreenInteractor) {
        self.router = router
        self.interactor = interactor
    }

    func registerUser(_ emailUser: String, _ password: String) {
        interactor.saveUser(emailUser, password)
    }
    
    func returnOnMain() {
        router.close()
    }
    
    func loginUser(_ emailUser: String, _ password: String) -> Bool {
        return interactor.loginUser(emailUser, password)
    }
}

