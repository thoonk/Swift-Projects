//
//  MockMovieListViewController.swift
//  MovieReviewTests
//
//  Created by thoonk on 2022/02/02.
//

import Foundation

@testable import MovieReview

final class MockMovieListViewController: MovieListProtocol {
    var isCalledSetupNavigationBar = false
    var isCalledSetupSearchBar = false
    var isCalledSetupLayout = false
    var isCalledUpdateSearchTableView = false
    var isCalledPushToMovieDetailViewController = false
    var isCalledUpdateCollectionView = false
    
    func setupNavigation() {
        isCalledSetupNavigationBar = true
    }
    
    func setupSearchBar() {
        isCalledSetupSearchBar = true
    }
    
    func setupLayout() {
        isCalledSetupLayout = true
    }
    
    func updateSearchTableView(isHidden: Bool) {
        isCalledUpdateSearchTableView = true
    }
    
    func pushToMovieDetailViewController(with movie: Movie) {
        isCalledPushToMovieDetailViewController = true
    }
    
    func updateCollectionView() {
        isCalledUpdateCollectionView = true
    }
}
