//
//  MainScreenRouter.swift
//  MovieBase
//
//  Created by Alexander on 28.03.2024.
//
import Foundation
import UIKit

final class MainScreenRouter: Router<MainScreenViewController>, MainScreenRouter.Routes {
    var descriptionScreenTransition: Transition = PushTransition()
    var favoriteMovieScreenTransition: Transition = PushTransition()
    var registrationScreenTransition: Transition = PushTransition()
    
    typealias Routes = DescriptionScreenRoute & FavoriteMovieScreenRoute & RegistrationScreenRoute
}

protocol MainScreenRoute {
    var mainScreenTransition: Transition { get }
    func openMainScreen()
}

extension MainScreenRoute where Self: RouterProtocol {
    func openMainScreen() {
        let router = MainScreenRouter()
        let viewController = MainScreenFactory.assembledScreen(router)
        openWithNextRouter(viewController, nextRouter: router, transition: mainScreenTransition)
    }
    
}
