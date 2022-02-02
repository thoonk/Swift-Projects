//
//  MovieListPresenterTest.swift
//  MovieReviewTests
//
//  Created by thoonk on 2022/02/02.
//

import XCTest

@testable import MovieReview

class MovieListPresenterTest: XCTestCase {
    var sut: MovieListPresenter! // system under test
    
    var viewController: MockMovieListViewController!
    var userDefaultsManager: MockUserDefaultsManager!
    var movieSearchManager: MockMovieSearchManager!
    
    override func setUp() {
        super.setUp()
        
        viewController = MockMovieListViewController()
        userDefaultsManager = MockUserDefaultsManager()
        movieSearchManager = MockMovieSearchManager()
        
        sut = MovieListPresenter(
            viewController: viewController,
            movieSearchManger: movieSearchManager,
            userDefaultsManager: userDefaultsManager
        )
    }
    
    override func tearDown() {
        sut = nil
        
        viewController = nil
        userDefaultsManager = nil
        movieSearchManager = nil
        
        super.tearDown()
    }
    
     // request 메서드가 성공하면 updateSearchTableview 실행 O
    func  whenSearchBarDidChangeIfRequestSucceeded() {
        movieSearchManager.needToSuccessRequest = true
        sut.searchBar(UISearchBar(), textDidChange: "")
        
        XCTAssertTrue(viewController.isCalledUpdateSearchTableView, "updateSearchTableView 실행됨.")
    }
     
     // request 메서드가 실패하면 updateSearchTableview 실행 X
    func whenSearchBarDidChangeIfRequestFailed() {
        movieSearchManager.needToSuccessRequest = false
        sut.searchBar(UISearchBar(), textDidChange: "")
        
        XCTAssertTrue(viewController.isCalledUpdateSearchTableView, "updateSearchTableView 실행되지 않음.")
    }
    
    func testIfViewDidLoadCalled() {
        sut.viewDidLoad()
        
        XCTAssertTrue(viewController.isCalledSetupNavigationBar)
        XCTAssertTrue(viewController.isCalledSetupSearchBar)
        XCTAssertTrue(viewController.isCalledSetupLayout)
    }
    
    func testIfViewWillAppearCalled() {
        sut.viewWillAppear()
        
        XCTAssertTrue(userDefaultsManager.isCalledGetMovies)
        XCTAssertTrue(viewController.isCalledUpdateCollectionView)
    }
    
    func testIfSearchBarTextDidBeginEditing() {
        sut.searchBarTextDidBeginEditing(UISearchBar())
        
        XCTAssertTrue(viewController.isCalledUpdateSearchTableView)
    }
    
    func testIfSearchBarCancelButtonClicked() {
        sut.searchBarCancelButtonClicked(UISearchBar())
        
        XCTAssertTrue(viewController.isCalledUpdateSearchTableView)
    }
}
