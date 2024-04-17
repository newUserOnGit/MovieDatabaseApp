//
//  MainScreenInteractor.swift
//  MovieBase
//
//  Created by Alexander on 28.03.2024.
//
import Foundation
import UIKit
import CoreData

protocol MainScreenInteractorProtocol {
    var movieOfTheList: [Movie] {get set}
    func fetchMovies() async throws -> [Movie]
    func saveMovieToDatabase(_ movie: [Movie])
    func getMovies() -> [FavoriteMovieEntity]
    func changeFavoriteStatus(model: CellViewModelProtocol)
    func convertFetchedMovies() -> [Movie]
    func deleteAllMoviesFromCoreData()
}

final class MainScreenInteractor: MainScreenInteractorProtocol {
    var movieOfTheList: [Movie] = []
    let networkConnect: NetworkConnection = .init()
    let database: DatabaseProtocol
    
    init(database: DatabaseProtocol) {
        self.database = database
    }
    
    func fetchMovies() async throws -> [Movie] {
        let moviesFromNetwork = try await networkConnect.fetchMovies()
        return moviesFromNetwork
    }
    
    func getMovies() -> [FavoriteMovieEntity] {
        return database.fetchAllMovies()
    }
    
    func saveMovieToDatabase(_ movie: [Movie]) {
        database.saveMovie(movie)
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
                     genres: favoritemovie.genres.components(separatedBy: ", "),
                     poster_path: .init(""),
                     posterUIImage: UIImage(data: favoritemovie.posterImage))
    }
    
    func convertFetchedMovies() -> [Movie] {
        let favoriteMovies = getMovies()
        return favoriteMovies.map { convertToMovie(from: $0) }
    }
    func deleteAllMoviesFromCoreData() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "FavoriteMovieEntity")
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            let context = DatabaseHelper.shared.persistentContainer.viewContext
            try context.execute(batchDeleteRequest)
        } catch {
            print("Failed to delete all movies: \(error)")
        }
    }
}

