//
//  FavoriteMovieScreenRouter.swift
//  MovieBase
//
//  Created by Alexander on 09.04.2024.
//

import Foundation
import UIKit

final class FavoriteMovieScreenRouter: Router<FavoriteMovieScreenViewController>, FavoriteMovieScreenRouter.Routes {
    var descriptionScreenTransition: Transition = PushTransition()
    
    typealias Routes = DescriptionScreenRoute
}

protocol FavoriteMovieScreenRoute {
    var favoriteMovieScreenTransition: Transition { get }
    
    func openFavoriteMovieScreen()
}

extension FavoriteMovieScreenRoute where Self: RouterProtocol {
    func openFavoriteMovieScreen() {
        let router = FavoriteMovieScreenRouter()
        let viewController = FavoriteMovieScreenFactory.assembledScreen(router)
        openWithNextRouter(viewController, nextRouter: router, transition: favoriteMovieScreenTransition)
    }
}
