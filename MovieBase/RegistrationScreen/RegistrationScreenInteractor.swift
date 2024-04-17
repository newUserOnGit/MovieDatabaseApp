//
//  RegistrationScreenInteractor.swift
//  MovieBase
//
//  Created by Alexander on 15.04.2024.
//  Copyright © 2024 ___ORGANIZATIONNAME___. All rights reserved.
//
import Foundation

protocol RegistrationScreenInteractorProtocol {
    func saveUser(_ userEmail: String, _ userpassword: String)
    func loginUser(_ emailUser: String, _ password: String) -> Bool
}

final class RegistrationScreenInteractor: RegistrationScreenInteractorProtocol {
    let cache = UserCache.shared
    
    func saveUser(_ userEmail: String, _ userPassword: String) {
        if !cache.compare(userName: userEmail, password: userPassword) {
            if isValidate(userEmail, userPassword) {
                cache.save(userName: userEmail, password: userPassword)
            }
        } else {
            
        }
    }
    func isValidate(_ userEmail: String, _ userPassword: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        let isEmailValid = emailPredicate.evaluate(with: userEmail)
        
        let passwordRegex = "^(?=.*[A-Z]).{8,}$" // Пароль должен быть не менее 8 символов и содержать хотя бы одну заглавную букву
        let passwordPredicate = NSPredicate(format:"SELF MATCHES %@", passwordRegex)
        let isPasswordValid = passwordPredicate.evaluate(with: userPassword)
        
        return isEmailValid && isPasswordValid
    }
    
    func loginUser(_ emailUser: String, _ password: String) -> Bool {
        cache.compare(userName: emailUser, password: password)
    }
}

