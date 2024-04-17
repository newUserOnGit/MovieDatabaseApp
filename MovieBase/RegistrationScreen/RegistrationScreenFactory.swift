//
//  RegistrationScreenFactory.swift
//  MovieBase
//
//  Created by Alexander on 15.04.2024.
//  Copyright © 2024 ___ORGANIZATIONNAME___. All rights reserved.
//

final class RegistrationScreenFactory {
    class func assembledScreen(_ router: RegistrationScreenRouter = .init()) -> RegistrationScreenViewController {
        let interactor = RegistrationScreenInteractor()
        let presenter = RegistrationScreenPresenter(router, interactor)
        let viewController = RegistrationScreenViewController(presenter: presenter)
        router.viewController = viewController
        return viewController
    }
}
