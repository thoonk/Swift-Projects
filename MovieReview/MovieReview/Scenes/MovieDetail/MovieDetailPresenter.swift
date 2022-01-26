//
//  MovieDetailPresenter.swift
//  MovieReview
//
//  Created by thoonk on 2022/01/26.
//

import UIKit

protocol MovieDetailProtocol: AnyObject {
    func setupLayout(with movie: Movie)
}

final class MovieDetailPresenter: NSObject {
    private unowned var viewController: MovieDetailProtocol?
    
    private var movie: Movie
    
    init(
        viewController: MovieDetailViewController,
        movie: Movie
    ) {
        self.viewController = viewController
        self.movie = movie
    }
    
    func viewDidLoad() {
        viewController?.setupLayout(with: movie)
    }
}
