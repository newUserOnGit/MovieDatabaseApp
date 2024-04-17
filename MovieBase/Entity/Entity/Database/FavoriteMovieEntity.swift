//
//  FavoriteMovieEntity.swift
//  MovieBase
//
//  Created by Alexander on 28.03.2024.
//

import Foundation
import CoreData
import UIKit


@objc(FavoriteMovieEntity)
public class FavoriteMovieEntity: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteMovieEntity> {
        return NSFetchRequest<FavoriteMovieEntity>(entityName: "FavoriteMovieEntity")
    }
    @NSManaged public var genres: String
    @NSManaged public var id: Int32
    @NSManaged public var isFavorite: Bool
    @NSManaged public var movieDescription: String
    @NSManaged public var name: String
    @NSManaged public var posterImage: Data
    @NSManaged public var poster_path: String
    @NSManaged public var year: String
}

extension FavoriteMovieEntity {
    func convertURLToData(urlString: String) -> Data? {
        if let url = URL(string: urlString),
           let imageData = try? Data(contentsOf: url) {
            return imageData
        }
        return nil
    }
    
    func saveMovieToDatabase(_ movie: Movie, context: NSManagedObjectContext) {
        context.perform {
            let newMovie = FavoriteMovieEntity(context: context)
            newMovie.id = Int32(movie._id)
            newMovie.name = movie.title
            newMovie.movieDescription = movie.overview
            newMovie.year = movie.release_date
            newMovie.posterImage = self.convertURLToData(urlString: movie.poster_path)!
            let genresNames = movie.genres
            let genresString = genresNames.joined(separator: ", ")
            newMovie.genres = genresString
            newMovie.isFavorite = false
            
            do {
                try context.save()
            } catch {
                print("Error saving movie to database: \(error.localizedDescription)")
            }
        }
    }
}
extension FavoriteMovieEntity {
    public var isSelected: Bool {
        get {
            return isFavorite
        }
        set {
            isFavorite = newValue
        }
    }
    
    convenience init?(context: NSManagedObjectContext, id: Int, name: String, description: String, year: String, poster: Data, genres: String, isSelect: Bool) {
        self.init(context: context)
        self.id = Int32(id)
        self.name = name
        self.movieDescription = description
        self.year = year
        self.posterImage = poster
        self.genres = genres
        self.isFavorite = isSelect
    }
}

