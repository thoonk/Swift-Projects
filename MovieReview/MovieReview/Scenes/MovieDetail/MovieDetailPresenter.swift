//
//  MovieDetailPresenter.swift
//  MovieReview
//
//  Created by thoonk on 2022/01/26.
//

import UIKit

protocol MovieDetailProtocol: AnyObject {
    func setupLayout(with movie: Movie)
    func setRightBarButton(with isLiked: Bool)
}

final class MovieDetailPresenter: NSObject {
    private unowned var viewController: MovieDetailProtocol?
    private let userDefaultsManager: UserDefaultsManagerProtocol
    private var movie: Movie
    
    init(
        viewController: MovieDetailViewController,
        movie: Movie,
        userDefaultsManager: UserDefaultsManagerProtocol = UserDefaultsManager()
    ) {
        self.viewController = viewController
        self.movie = movie
        self.userDefaultsManager = userDefaultsManager
    }
    
    func viewDidLoad() {
        viewController?.setupLayout(with: movie)
        viewController?.setRightBarButton(with: movie.isLiked)
    }
    
    func didTapRightBarButtonItem() {
        movie.isLiked.toggle()
        viewController?.setRightBarButton(with: movie.isLiked)

        if movie.isLiked == true {
            userDefaultsManager.addMovie(movie)
        } else {
            userDefaultsManager.removeMovie(movie)
        }
    }
}
