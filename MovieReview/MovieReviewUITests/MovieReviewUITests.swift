//
//  MovieReviewUITests.swift
//  MovieReviewUITests
//
//  Created by thoonk on 2022/01/21.
//

import XCTest

class MovieReviewUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false
        
        app = XCUIApplication()
        app.launch()
    }
    
    override func tearDown() {
        super.tearDown()
        
        app = nil
    }
    
    func testNavigationTitleIfExistMovieReview() {
        let exsistNaviagtionBar = app.navigationBars["영화 평점"].exists
        
        XCTAssert(exsistNaviagtionBar)
    }
    
    func testNavigationIfExistSearchBar() {
        let existSearchBar = app.navigationBars["영화 평점"]
            .searchFields["Search"]
            .exists
        
        XCTAssertTrue(existSearchBar)
    }
    
    func testSearchBarIFExistCancelButton() {
        let navigationBar = app.navigationBars["영화 평점"]
        navigationBar.searchFields["Search"]
            .tap()
        
        let existCancelButton = navigationBar
            .buttons["Cancel"]
            .exists
        
        XCTAssertTrue(existCancelButton)
    }
    
    // MARK: - BDD
    enum CellData: String {
        case existMovie = "<b>점퍼</b>"
        case notExistsMovie = "007"
    }
    
    func testIfFavoritesTrue() {
        let existsCell = app.collectionViews
            .cells
            .containing(.staticText, identifier: CellData.existMovie.rawValue)
            .element
            .exists
        
        XCTAssertTrue(existsCell, "Title이 표시된 Cell이 존재함.")
    }
    
    func testIfFavoritesFalse() {
        let existsCell = app.collectionViews
            .cells
            .containing(.staticText, identifier: CellData.notExistsMovie.rawValue)
            .element
            .exists
        
        XCTAssertFalse(existsCell, "Title이 표시된 Cell이 존재하지 않음.")
    }
}
