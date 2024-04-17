import CoreData

class DatabaseHelper {
    static let shared = DatabaseHelper()
    private init() {}
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
}

protocol DatabaseProtocol {
    func saveMovie(_ movies: [Movie])
    func fetchAllMovies() -> [FavoriteMovieEntity]
    func changeFavoriteStatus(model: CellViewModelProtocol)
}

extension DatabaseHelper: DatabaseProtocol {
    func saveMovie(_ movies: [Movie]) {
        let context = DatabaseHelper.shared.persistentContainer.viewContext
        for movie in movies {
            guard let entity = NSEntityDescription.entity(forEntityName: "FavoriteMovieEntity", in: context) else {
                continue
            }
            let movieId = Int32(movie._id)
            
            // Проверка на наличие контекста с таким же id
            let fetchRequest: NSFetchRequest<FavoriteMovieEntity> = FavoriteMovieEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %d", movieId)
            
            do {
                let existingMovies = try context.fetch(fetchRequest)
                
                let newMovie: FavoriteMovieEntity
                if let existingMovie = existingMovies.first {
                    // Если фильм уже существует, обновляем только свойства, которые могли измениться
                    newMovie = existingMovie
                } else {
                    newMovie = FavoriteMovieEntity(entity: entity, insertInto: context)
                    newMovie.isFavorite = false // Устанавливаем значение по умолчанию только если фильм новый
                }
                newMovie.id = movieId
                newMovie.name = movie.title
                newMovie.movieDescription = movie.overview
                newMovie.year = movie.release_date
                newMovie.posterImage = convertURLToData(urlString: movie.poster_path) ?? Data()
                newMovie.genres = movie.genres.joined(separator: ", ")
            } catch {
                print("Error fetching existing movies: \(error)")
            }
        }
        saveContext()
    }
    
    func convertURLToData(urlString: String) -> Data? {
        if let url = URL(string: urlString),
           let imageData = try? Data(contentsOf: url) {
            return imageData
        }
        return nil
    }
    
    func fetchAllMovies() -> [FavoriteMovieEntity] {
        let context = DatabaseHelper.shared.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<FavoriteMovieEntity> = FavoriteMovieEntity.fetchRequest()
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Error fetching movies: \(error)")
            return []
        }
    }
    
    func changeFavoriteStatus(model: CellViewModelProtocol) {
        let context = DatabaseHelper.shared.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<FavoriteMovieEntity> = FavoriteMovieEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", model.title)
        do {
            let fetchedResults = try context.fetch(fetchRequest)
            if let entity = fetchedResults.first {
                entity.isFavorite.toggle()
                try context.save()
            }
        } catch {
            print("Fetch failed: \(error.localizedDescription)")
        }
    }
    
    func saveContext() {
        let context = DatabaseHelper.shared.persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
