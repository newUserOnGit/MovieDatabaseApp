//
//  MainScreenView.swift
//  MovieBase
//
//  Created by Alexander on 28.03.2024.
//

import UIKit
import PinLayout

class MainScreenCellView: UITableViewCell {
    weak var delegate: MainScreenCellDelegate?
    let padding: CGFloat = 16
    var onTapFavorite: (() -> Void)?
    
    let name: UILabel = {
        let nameMovie = UILabel()
        nameMovie.font = UIFont.italicSystemFont(ofSize: 20)
        nameMovie.textAlignment = .center
        nameMovie.backgroundColor = .clear
        return nameMovie
    }()
    
    let shortDescription: UILabel = {
        let shortDescription = UILabel()
        shortDescription.font = UIFont.boldSystemFont(ofSize: 18)
        shortDescription.numberOfLines = 4
        shortDescription.lineBreakMode = .byTruncatingTail
        return shortDescription
    }()
    
    let poster: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        image.layer.cornerRadius = 40
        return image
    }()
    
    let addToFavorite: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        button.tintColor = .systemBlue
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been imlemented")
    }
    
    private func setupSubviews() {
        contentView.addSubviews(name, shortDescription, poster, addToFavorite)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureSubviews()
    }
    
    private func configureSubviews() {
        poster.pin
            .topLeft(padding)
            .marginBottom(padding)
            .width(35%)
            .aspectRatio()
        
        name.pin
            .after(of: poster, aligned: .top)
            .right()
            .marginHorizontal(padding)
            .sizeToFit(.width)
        
        addToFavorite.pin
            .bottom()
            .right()
            .margin(padding)
        
        shortDescription.pin
            .left(to: poster.edge.right)
            .right(to: addToFavorite.edge.left)
            .below(of: name)
            .margin(padding)
            .marginHorizontal(padding)
            .sizeToFit(.width)
            .bottom()
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        contentView.autoSizeThatFits(size, layoutClosure: configureSubviews)
    }
    
    func configure(model: MainScreenCellViewModel, onTapFavorite: @escaping () -> Void) {
        name.text = model.title
        shortDescription.text = model.description
        poster.image = model.poster
        self.onTapFavorite = onTapFavorite
        let imageButton = model.isFavorite ? "star.fill" : "star"
        addToFavorite.setImage(UIImage(systemName: imageButton), for: .normal)
        addToFavorite.addTarget(self, action: #selector(tapOnButton), for: .touchUpInside)
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    @objc
    func tapOnButton() {
        onTapFavorite?()
        delegate?.didTapFavoriteButton(cell: self)
    }
}

struct MainScreenCellViewModel: CellViewModelProtocol {
    var title: String
    var description: String
    var poster: UIImage?
    var isFavorite: Bool
}

protocol MainScreenCellDelegate: AnyObject {
    func didTapFavoriteButton(cell: MainScreenCellView)
}
