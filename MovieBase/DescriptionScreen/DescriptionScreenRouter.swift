//
//  DescriptionScreenRouter.swift
//  MovieBase
//
//  Created by Alexander on 28.03.2024.
//

import Foundation
import UIKit

final class DescriptionScreenRouter: Router<DescriptionScreenViewController>, DescriptionScreenRouter.Routes {
    
    
    typealias Routes = Any
}

protocol DescriptionScreenRoute {
    var descriptionScreenTransition: Transition { get }
    func openDescriptionScreen(movie: Movie)
}

extension DescriptionScreenRoute where Self: RouterProtocol {
    func openDescriptionScreen(movie: Movie) {
        let router = DescriptionScreenRouter()
        let viewController = DescriptionScreenFactory.assembledScreen(router, movie: movie)
        openWithNextRouter(viewController, nextRouter: router, transition: descriptionScreenTransition)
    }
}
