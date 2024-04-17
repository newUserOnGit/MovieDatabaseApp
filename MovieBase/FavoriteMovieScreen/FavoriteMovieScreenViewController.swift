//
//  FavoriteMovieScreenViewController.swift
//  MovieBase
//
//  Created by Alexander on 09.04.2024.
//

import Foundation
import UIKit
import PinLayout


final class FavoriteMovieScreenViewController: UIViewController {
    private var presenter: FavoriteMovieScreenPresenterProtocol
    var onTapFavorite: (() -> Void)?
    
    private var favoriteMovieScreenTableView: UITableView = {
        let tableview = UITableView()
        tableview.estimatedRowHeight = 120
        tableview.rowHeight = UITableView.automaticDimension
        tableview.register(FavoriteMovieScreenCellView.self, forCellReuseIdentifier: "FavoriteMovieScreenCellView")
        tableview.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return tableview
    }()
    
    init(presenter: FavoriteMovieScreenPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        setupSubviews()
        Task {
            do {
                await presenter.viewAppear()
                self.favoriteMovieScreenTableView.reloadData()
            }
        }
    }
    
    private func setupSubviews() {
        view.addSubviews(favoriteMovieScreenTableView)
        favoriteMovieScreenTableView.dataSource = self
        favoriteMovieScreenTableView.delegate = self
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        favoriteMovieScreenTableView.pin
            .top(view.pin.safeArea)
            .left()
            .right()
            .bottom(view.pin.safeArea)
    }
}

extension FavoriteMovieScreenViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.viewModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteMovieScreenCellView", for: indexPath) as? FavoriteMovieScreenCellView else {
            fatalError()
        }
        let model = presenter.viewModel[indexPath.row]
        cell.configure(model: model) { [weak self] in
            guard let self else { return }
            self.presenter.changeIsFavorite(indexPath: indexPath, cell: cell)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.goToDescriptionMovieScreen(atIndex: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension FavoriteMovieScreenViewController: FavoriteMovieScreenCellDelegate {
    func didTapFavoriteButton(cell: FavoriteMovieScreenCellView) {
        guard let indexPath = favoriteMovieScreenTableView.indexPath(for: cell) else {
            return
        }
        presenter.changeIsFavorite(indexPath: indexPath, cell: cell)
    }
}

struct FavoriteMovieScreenViewModel: CellViewModelProtocol {
    var title: String
    var description: String
    var poster: UIImage?
    var isFavorite: Bool
}
