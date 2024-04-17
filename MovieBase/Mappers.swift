//
//  Mapper.swift
//  MovieBase
//
//  Created by Alexander on 05.04.2024.
//


import Foundation
import UIKit

struct MapperMainScreen {
    func map(entity: Movie) -> MainScreenCellViewModel {
        return MainScreenCellViewModel(title: entity.title,
                                   description: entity.overview,
                                   poster: entity.posterUIImage,
                                   isFavorite: entity.isFavorite ?? false)
    }
}

struct MapperDescriptionScreen {
    func map(entity: Movie) -> DescriptionScreenViewModel {
        return DescriptionScreenViewModel(name: entity.title,
                                          description: entity.overview,
                                          poster: entity.posterUIImage,
                                          year: entity.release_date,
                                          genres: entity.genres.joined(separator: ", "))
    }
}

struct MapperFavoriteMovieScreen {
    func map(entity: Movie) -> FavoriteMovieScreenViewModel {
        return FavoriteMovieScreenViewModel(title: entity.title,
                                            description: entity.overview,
                                            poster: entity.posterUIImage,
                                            isFavorite: entity.isFavorite ?? true)
    }
}


protocol CellViewModelProtocol {
    var title: String { get set }
    var description: String { get set }
    var poster: UIImage? { get set }
    var isFavorite: Bool {get set}
}
