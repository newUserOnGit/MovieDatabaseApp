//
//  FavoriteMovieScreenFactory.swift
//  MovieBase
//
//  Created by Alexander on 09.04.2024.
//
final class FavoriteMovieScreenFactory {
    class func assembledScreen(_ router: FavoriteMovieScreenRouter = .init(), database: DatabaseProtocol = DatabaseHelper.shared) -> FavoriteMovieScreenViewController {
        let interactor = FavoriteMovieScreenInteractor(database: database)
        let presenter = FavoriteMovieScreenPresenter(interactor: interactor, router: router)
        let viewController = FavoriteMovieScreenViewController(presenter: presenter)
        router.viewController = viewController
        return viewController
    }
}

