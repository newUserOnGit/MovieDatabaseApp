//
//  DescriptionScreenFactory.swift
//  MovieBase
//
//  Created by Alexander on 08.04.2024.
//

import Foundation


final class DescriptionScreenFactory {
    class func assembledScreen(_ router: DescriptionScreenRouter = .init(),  movie: Movie) -> DescriptionScreenViewController {
        let interactor = DescriptionScreenInteractor(movie: movie)
        let presenter = DescriptionScreenPresenter(router: router, interactor: interactor)
        let viewController = DescriptionScreenViewController(presenter: presenter)
        router.viewController = viewController
        return viewController
    }
}
