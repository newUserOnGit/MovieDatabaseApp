//
//  MainScreenViewController.swift
//  MovieBase
//
//  Created by Alexander on 28.03.2024.
//

import Foundation
import UIKit
import PinLayout

final class MainScreenViewController: UIViewController, MainScreenPresenterOutput {
    private let presenter: MainScreenPresenterProtocol
    var onTapFavorite: (() -> Void)?
    
    private var mainScreenTableView: UITableView = {
        let tableview = UITableView()
        tableview.estimatedRowHeight = 120
        tableview.rowHeight = UITableView.automaticDimension
        tableview.register(MainScreenCellView.self, forCellReuseIdentifier: "MainScreenCellView")
        tableview.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return tableview
    }()
    private var input: MainScreenPresenterInput = MainScreenPresenterInputImpl()
    init(presenter: MainScreenPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        presenter.output = self
        input.movieSelected = { index in
            presenter.goToDescriptionMovieScreen(atIndex: index)}
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Favorite",
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(tapOnFavorite))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sing in",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(tapOnSingIn))
        setupSubviews()
        Task {
            do {
                await presenter.viewAppear()
                self.mainScreenTableView.reloadData()
            }
        }
    }
    private func setupSubviews() {
        view.addSubviews(mainScreenTableView)
        mainScreenTableView.dataSource = self
        mainScreenTableView.delegate = self
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        mainScreenTableView.pin
            .top(view.pin.safeArea)
            .left()
            .right()
            .bottom(view.pin.safeArea)
    }
    @objc
    func tapOnFavorite() {
        presenter.goToFavoriteMovieScreen()
    }
    @objc
    func tapOnSingIn() {
        presenter.goToRegistrationScreen()
    }
    func updateMainScreen(movies: [MainScreenCellViewModel]) {
        DispatchQueue.main.async {
            self.mainScreenTableView.reloadData()
        }
        
    }
}

extension MainScreenViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.cellsViewModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MainScreenCellView", for: indexPath) as? MainScreenCellView else {
            fatalError()
        }
        let model = presenter.cellsViewModel[indexPath.row]
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

extension MainScreenViewController: MainScreenCellDelegate {
    func didTapFavoriteButton(cell: MainScreenCellView) {
        guard let indexPath = mainScreenTableView.indexPath(for: cell) else {
            return
        }
        presenter.changeIsFavorite(indexPath: indexPath, cell: cell)
    }
}

