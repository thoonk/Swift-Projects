//
//  NewsListPresenterTest.swift
//  KeywordNewsTests
//
//  Created by thoonk on 2022/02/08.
//

import XCTest

@testable import KeywordNews

class NewsListPresenterTest: XCTestCase {
    var sut: NewsListPresenter!
    
    var viewController: MockNewsListViewController!
    var newsSearchManager: MockNewsSearchManager!
    
    override func setUp() {
        super.setUp()
        
        viewController = MockNewsListViewController()
        newsSearchManager = MockNewsSearchManager()
        
        sut = NewsListPresenter(
            viewController: viewController,
            newsSearchManager: newsSearchManager
        )
    }
    
    override func tearDown() {
        sut = nil
        viewController = nil
        newsSearchManager = nil
        
        super.tearDown()
    }
    
    func test_viewDidLoadCalled() {
        sut.viewDidLoad()
        
        XCTAssertTrue(viewController.isCalledSetupNavigationBar)
        XCTAssertTrue(viewController.isCalledSetupLayout)
    }
    
    func test_didRefreshTableViewCalledIfRequestFailed() {
        newsSearchManager.error = NSError() as Error
        
        sut.didRefreshTableView()
        
        XCTAssertFalse(viewController.isCalledReloadTableView)
        XCTAssertFalse(viewController.isCalledEndRefreshing)
    }
    
    func test_didRefreshTableViewCalledIfRequestSucceeded() {
        newsSearchManager.error = nil
        
        sut.didRefreshTableView()
        
        XCTAssertTrue(viewController.isCalledReloadTableView)
        XCTAssertTrue(viewController.isCalledEndRefreshing)
    }
}
