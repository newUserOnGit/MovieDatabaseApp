//
//  MainScreenFactory.swift
//  MovieBase
//
//  Created by Alexander on 28.03.2024.
//

final class MainScreenFactory {
    class func assembledScreen(_ router: MainScreenRouter = .init(), database: DatabaseProtocol = DatabaseHelper.shared) -> MainScreenViewController {
        let interactor = MainScreenInteractor(database: database)
        let presenter = MainScreenPresenter(interactor: interactor, router: router)
        let viewController = MainScreenViewController(presenter: presenter)
        router.viewController = viewController
        return viewController
    }
}
