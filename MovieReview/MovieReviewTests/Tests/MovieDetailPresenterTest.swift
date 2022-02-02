//
//  MovieDetailPresenterTest.swift
//  MovieReviewTests
//
//  Created by thoonk on 2022/02/02.
//

import XCTest

@testable import MovieReview

class MovieDetailPresenterTest: XCTestCase {
    
    var sut: MovieDetailPresenter!
    
    var viewController: MockMovieDetailViewController!
    var movie: Movie!
    var userDefaultsManager: MockUserDefaultsManager!
    
    override func setUp() {
        super.setUp()
        
        viewController = MockMovieDetailViewController()
        movie = Movie(title: "", imageURL: "", pubDate: "", director: "", actor: "", userRating: "")
        userDefaultsManager = MockUserDefaultsManager()
        
        sut = MovieDetailPresenter(
            viewController: viewController,
            movie: movie,
            userDefaultsManager: userDefaultsManager
        )
    }
    
    override func tearDown() {
        sut = nil
        
        viewController = nil
        movie = nil
        userDefaultsManager = nil
        
        super.tearDown()
    }
    
    func testIfViewDidLoadCalled() {
        sut.viewDidLoad()
        
        XCTAssertTrue(viewController.isCalledSetupLayout)
        XCTAssertTrue(viewController.isCalledSetRightBarButton)
    }
    
    func testWhenDidTapRightBarButtonIfIsLikedToBeTrue() {
        movie.isLiked = false
        
        sut = MovieDetailPresenter(
            viewController: viewController,
            movie: movie,
            userDefaultsManager: userDefaultsManager
        )
        
        sut.didTapRightBarButtonItem()
        
        XCTAssertTrue(userDefaultsManager.isCalledAddMovie)
        XCTAssertFalse(userDefaultsManager.isCalledRemoveMovie)
        XCTAssertTrue(viewController.isCalledSetRightBarButton)
    }
    
    func testWhenDidTapRightBarButtonIfIsLikedToBeFalse() {
        movie.isLiked = true
        
        sut = MovieDetailPresenter(
            viewController: viewController,
            movie: movie,
            userDefaultsManager: userDefaultsManager
        )
        
        sut.didTapRightBarButtonItem()
        
        XCTAssertFalse(userDefaultsManager.isCalledAddMovie)
        XCTAssertTrue(userDefaultsManager.isCalledRemoveMovie)
        XCTAssertTrue(viewController.isCalledSetRightBarButton)
    }
}
