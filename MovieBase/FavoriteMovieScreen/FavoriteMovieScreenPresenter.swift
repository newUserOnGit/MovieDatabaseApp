//
//  FavoriteMovieScreenPresenter.swift
//  MovieBase
//
//  Created by Alexander on 09.04.2024.
//

import Foundation
import UIKit

protocol FavoriteMovieScreenPresenterOutput: AnyObject {
    func update(movies: [FavoriteMovieScreenViewModel])
}
protocol FavoriteMovieScreenPresenterInput {
    var movieSelected: ((Int) -> ())? {get set}
}
protocol FavoriteMovieScreenPresenterProtocol {
    var viewModel: [FavoriteMovieScreenViewModel] {get}
    func viewAppear() async
    func changeIsFavorite(indexPath: IndexPath, cell: FavoriteMovieScreenCellView)
    func goToDescriptionMovieScreen(atIndex: Int)
    var input: FavoriteMovieScreenPresenterInput {get set}
    var output: FavoriteMovieScreenPresenterOutput? {get}
}

final class FavoriteMovieScreenPresenter: FavoriteMovieScreenPresenterProtocol {
    weak var output: FavoriteMovieScreenPresenterOutput?
    var input: FavoriteMovieScreenPresenterInput = FavoriteMovieScreenPresenterInputImpl()
    private var movies: [Movie] = []
    private let interactor: FavoriteMovieScreenInteractorProtocol
    var viewModel: [FavoriteMovieScreenViewModel] {
        self.movies.map { movie in
            return self.mapper.map(entity: movie)
        }
    }
    private let mapper: MapperFavoriteMovieScreen
    private let router: FavoriteMovieScreenRouter
    
    init(interactor: FavoriteMovieScreenInteractorProtocol, mapper: MapperFavoriteMovieScreen = MapperFavoriteMovieScreen(), router: FavoriteMovieScreenRouter) {
        self.interactor = interactor
        self.mapper = mapper
        self.router = router
    }
    
    func viewAppear() async {
        let favoriteMovies = interactor.convertFetchedMovies()
        movies = favoriteMovies
        self.output?.update(movies: viewModel)
    }
    
    func changeIsFavorite(indexPath: IndexPath, cell: FavoriteMovieScreenCellView) {
        var model = viewModel[indexPath.row]
        
        if model.isFavorite {
            model.isFavorite = false
            interactor.changeFavoriteStatus(model: model)
            cell.addToFavorite.setImage(UIImage(systemName: "star"), for: .normal)
        } else {
            model.isFavorite = true
            interactor.changeFavoriteStatus(model: model)
            cell.addToFavorite.setImage(UIImage(systemName: "star.fill"), for: .normal)
        }
        let movieIndex = indexPath.row
        movies[movieIndex].isFavorite = model.isFavorite
        output?.update(movies: viewModel)
    }
    
    func goToDescriptionMovieScreen(atIndex: Int) {
        _ = viewModel[atIndex]
        router.openDescriptionScreen(movie: self.movies[atIndex])
    }
}
struct FavoriteMovieScreenPresenterInputImpl: FavoriteMovieScreenPresenterInput {
    var movieSelected: ((Int) -> ())?
}
