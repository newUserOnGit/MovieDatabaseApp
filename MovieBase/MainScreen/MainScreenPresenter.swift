//
//  MainScreenPresenter.swift
//  MovieBase
//
//  Created by Alexander on 28.03.2024.
//

import Foundation
import UIKit

protocol MainScreenPresenterProtocol: AnyObject {
    func viewAppear() async
    func updateDatabase() async
    func goToDescriptionMovieScreen(atIndex: Int)
    func goToFavoriteMovieScreen()
    func goToRegistrationScreen()
    func changeIsFavorite(indexPath: IndexPath, cell: MainScreenCellView)
    var cellsViewModel: [MainScreenCellViewModel] {get}
    var output: MainScreenPresenterOutput? {get set}
    var input: MainScreenPresenterInput {get}
}

protocol MainScreenPresenterOutput: AnyObject {
    func updateMainScreen(movies: [MainScreenCellViewModel])
}

protocol MainScreenPresenterInput {
    var movieSelected: ((Int) -> ())? {get set}
}

final class MainScreenPresenter: MainScreenPresenterProtocol {
    weak var output: MainScreenPresenterOutput?
    var input: MainScreenPresenterInput = MainScreenPresenterInputImpl()
    private var movies: [Movie] = []
    private let interactor: MainScreenInteractorProtocol
    var cellsViewModel: [MainScreenCellViewModel] {
        self.movies.map { movie in
            return self.mapper.map(entity: movie)
        }
    }
    private let mapper: MapperMainScreen
    private let router: MainScreenRouter
    
    init(interactor: MainScreenInteractorProtocol, mapper: MapperMainScreen = MapperMainScreen(), router: MainScreenRouter) {
        self.interactor = interactor
        self.mapper = mapper
        self.router = router
    }
    
    func updateDatabase() async {
        do {
            let fetchedMovies = try await self.interactor.fetchMovies()
            interactor.saveMovieToDatabase(fetchedMovies)
            self.movies = interactor.convertFetchedMovies()
        } catch {
            fatalError("\(error)")
        }
    }
    
    func viewAppear() async {
        let savedMovie = interactor.convertFetchedMovies()
        self.movies = savedMovie
        output?.updateMainScreen(movies: cellsViewModel)
        Task {
           await updateDatabase()
        }
    }
    
    func goToFavoriteMovieScreen() {
        router.openFavoriteMovieScreen()
    }
    
    func goToRegistrationScreen() {
        router.openRegistrationScreen()
    }
    
    func changeIsFavorite(indexPath: IndexPath, cell: MainScreenCellView) {
        var model = cellsViewModel[indexPath.row]
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
        output?.updateMainScreen(movies: cellsViewModel)
    }
    
    func goToDescriptionMovieScreen(atIndex: Int) {
        _ = cellsViewModel[atIndex]
        router.openDescriptionScreen(movie: self.movies[atIndex])
    }
}

struct MainScreenPresenterInputImpl: MainScreenPresenterInput {
    var movieSelected: ((Int) -> ())?
}
