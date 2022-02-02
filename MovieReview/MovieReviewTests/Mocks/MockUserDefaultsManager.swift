//
//  MockUserDefaultsManager.swift
//  MovieReviewTests
//
//  Created by thoonk on 2022/02/02.
//

import Foundation

@testable import MovieReview

final class MockUserDefaultsManager: UserDefaultsManagerProtocol {
    
    var isCalledGetMovies = false
    var isCalledAddMovie = false
    var isCalledRemoveMovie = false
    
    func getMovies() -> [Movie] {
        isCalledGetMovies = true
        return []
    }
    
    func addMovie(_ newValue: Movie) {
        isCalledAddMovie = true
    }
    
    func removeMovie(_ value: Movie) {
        isCalledRemoveMovie = true
    }
}
