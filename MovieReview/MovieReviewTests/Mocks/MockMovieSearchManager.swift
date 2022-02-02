//
//  MockMovieSearchManager.swift
//  MovieReviewTests
//
//  Created by thoonk on 2022/02/02.
//

import Foundation

@testable import MovieReview

final class MockMovieSearchManager: MovieSearchManagerProtocol {
    var isCalledRequest = false
    
    var needToSuccessRequest = false
    
    func request(from keyword: String, completion: @escaping ([Movie]) -> Void) {
        isCalledRequest = true
        
        if needToSuccessRequest {
            completion([])
        }
    }
}
