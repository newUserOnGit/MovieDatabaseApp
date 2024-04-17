//
//  DescriptionScreenViewController.swift
//  MovieBase
//
//  Created by Alexander on 08.04.2024.
//

import Foundation
import UIKit
import PinLayout

protocol DescriptionScreenViewProtocol {
    var name: String {get set}
    var description: String {get set}
    var poster: UIImage? {get set}
    var year: String {get set}
    var genres: String {get set}
}

struct DescriptionScreenViewModel: DescriptionScreenViewProtocol {
    var name: String
    var description: String
    var poster: UIImage?
    var year: String
    var genres: String
}

final class DescriptionScreenViewController: UIViewController {
    private let presenter: DescriptionScreenPresenterProtocol
    private let padding: CGFloat = 16
    
    init(presenter: DescriptionScreenPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let nameLabel: UILabel = {
        let nameMovie = UILabel()
        nameMovie.font = UIFont.systemFont(ofSize: 15)
        nameMovie.textAlignment = .center
        nameMovie.backgroundColor = .clear
        return nameMovie
    }()
    
    let descriptionLabel: UILabel = {
        let description = UILabel()
        description.font = UIFont.italicSystemFont(ofSize: 18)
        description.numberOfLines = 0
        description.lineBreakMode = .byWordWrapping
        return description
    }()
    
    let genresLable: UILabel = {
        let genres = UILabel()
        genres.font = UIFont.systemFont(ofSize: 16)
        genres.numberOfLines = 0
        genres.lineBreakMode = .byWordWrapping
        return genres
    }()
    
    var posterImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        image.layer.cornerRadius = 40
        image.translatesAutoresizingMaskIntoConstraints = true
        return image
    }()
    
    let yearLabel: UILabel = {
        let year = UILabel()
        year.font = UIFont.systemFont(ofSize: 16)
        year.textAlignment = .center
        year.backgroundColor = .clear
        return year
    }()
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = UIColor.clear
        return scrollView
    }()
}

extension DescriptionScreenViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        viewDescriptionScreen()
        view.backgroundColor = .white
        self.configure(model: self.presenter.viewModel)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layout()
    }
    
    func viewDescriptionScreen() {
        view.addSubview(scrollView)
        scrollView.addSubviews(nameLabel,
                               descriptionLabel,
                               posterImageView,
                               genresLable,
                               yearLabel)
    }
    
    func configure(model: DescriptionScreenViewModel) {
        descriptionLabel.text = model.description
        genresLable.text = model.genres
        yearLabel.text = String(model.year)
        posterImageView.image = model.poster
        self.title = model.name
    }
}



extension DescriptionScreenViewController {
    func layout() {
        scrollView.pin.all()
        
        posterImageView.pin
            .topCenter()
            .marginTop(.zero)
            .marginBottom(padding)
            .width(50%)
            .aspectRatio()
        
        yearLabel.pin
            .below(of: posterImageView)
            .left()
            .margin(padding)
            .sizeToFit()
        
        genresLable.pin
            .below(of: yearLabel)
            .left(padding)
            .marginTop(padding)
            .marginRight(padding)
            .sizeToFit()
        
        descriptionLabel.pin
            .horizontally(padding)
            .below(of: genresLable)
            .marginTop(padding)
            .sizeToFit(.width)
        
        scrollView.contentSize = CGSize(width: scrollView.bounds.width, height: descriptionLabel.frame.maxY + padding)
    }
}
