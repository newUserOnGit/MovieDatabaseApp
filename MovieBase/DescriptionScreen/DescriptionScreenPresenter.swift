//
//  DescriptionScreenPresenter.swift
//  MovieBase
//
//  Created by Alexander on 08.04.2024.
//

import Foundation


protocol DescriptionScreenPresenterProtocol: AnyObject {
    var viewModel: DescriptionScreenViewModel {get}
}

final class DescriptionScreenPresenter: DescriptionScreenPresenterProtocol {
    private let router: DescriptionScreenRouter
    private let interactor: DescriptionScreenInteractorProtocol
    private let mapper: MapperDescriptionScreen
    let viewModel: DescriptionScreenViewModel
    
    init(router: DescriptionScreenRouter,
         interactor: DescriptionScreenInteractorProtocol,
         mapper: MapperDescriptionScreen = MapperDescriptionScreen()) {
        self.mapper = mapper
        self.router = router
        self.interactor = interactor
        self.viewModel = self.mapper.map(entity: self.interactor.movie)
    }
}
