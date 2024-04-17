//
//  DescriptionScreenInteractor.swift
//  MovieBase
//
//  Created by Alexander on 08.04.2024.
//
import Foundation
import UIKit
import CoreData

protocol DescriptionScreenInteractorProtocol: AnyObject {
    var movie: Movie {get}
}

final class DescriptionScreenInteractor: DescriptionScreenInteractorProtocol {
    var movie: Movie
    init(movie: Movie) {
        self.movie = movie
    }
}
