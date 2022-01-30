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
}
