//
//  FavoriteMovieScreenInteractor.swift
//  MovieBase
//
//  Created by Alexander on 09.04.2024.
//

import Foundation
import UIKit

protocol FavoriteMovieScreenInteractorProtocol {
    func getMovies() -> [FavoriteMovieEntity]
    func changeFavoriteStatus(model: CellViewModelProtocol)
    func convertFetchedMovies() -> [Movie]
}

final class FavoriteMovieScreenInteractor: FavoriteMovieScreenInteractorProtocol {
    let database: DatabaseProtocol
    
    init(database: DatabaseProtocol) {
        self.database = database
    }
    
    func getMovies() -> [FavoriteMovieEntity] {
        let allMovies = database.fetchAllMovies()
        let favoriteMovies = allMovies.filter({ $0.isFavorite })
        return favoriteMovies
    }
    
    func changeFavoriteStatus(model: CellViewModelProtocol) {
        if let cellViewModel = model as? CellViewModelProtocol {
            database.changeFavoriteStatus(model: cellViewModel)
        } else {
            fatalError()
        }
    }
    
    func convertToMovie(from favoritemovie: FavoriteMovieEntity) -> Movie {
        
        return Movie(_id: Int(favoritemovie.id),
                     title: favoritemovie.name,
                     overview: favoritemovie.movieDescription,
                     release_date: favoritemovie.year,
                     genres: favoritemovie.genres.components(separatedBy: (", ")),
                     poster_path: .init(""),
                     posterUIImage: UIImage(data: favoritemovie.posterImage))
    }
    
    func convertFetchedMovies() -> [Movie] {
        let favoriteMovies = getMovies()
        return favoriteMovies.map { convertToMovie(from: $0) }
    }
    
}
