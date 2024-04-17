//
//  RegistrationScreenRouter.swift
//  MovieBase
//
//  Created by Alexander on 15.04.2024.
//  Copyright © 2024 ___ORGANIZATIONNAME___. All rights reserved.
//

final class RegistrationScreenRouter: Router<RegistrationScreenViewController>, RegistrationScreenRouter.Routes {
    var mainScreenTransition: Transition = PushTransition()
    
    typealias Routes = MainScreenRoute
}

protocol RegistrationScreenRoute {
    var registrationScreenTransition: Transition { get }
    func openRegistrationScreen()
}
extension RegistrationScreenRoute where Self: RouterProtocol {
    func openRegistrationScreen() {
        let router = RegistrationScreenRouter()
        let viewController = RegistrationScreenFactory.assembledScreen(router)
        openWithNextRouter(viewController, nextRouter: router, transition: registrationScreenTransition)
    }
}
