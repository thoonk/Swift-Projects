//
//  MockMovieDetailViewController.swift
//  MovieReviewTests
//
//  Created by thoonk on 2022/02/02.
//

import Foundation

@testable import MovieReview

final class MockMovieDetailViewController: MovieDetailProtocol {
    
    var isCalledSetupLayout = false
    var isCalledSetRightBarButton = false
    var settedIsLiked = false
    
    func setupLayout(with movie: Movie) {
        isCalledSetupLayout = true
    }
    
    func setRightBarButton(with isLiked: Bool) {
        settedIsLiked = isLiked
        isCalledSetRightBarButton = true
    }
}
