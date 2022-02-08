//
//  MockNewsSearchManager.swift
//  KeywordNewsTests
//
//  Created by thoonk on 2022/02/08.
//

import Foundation

@testable import KeywordNews

final class MockNewsSearchManager: NewsSearchManagerProtocol {
    var error: Error?
    var isCalledRequest = false
    
    func request(
        from keyword: String,
        start: Int,
        display: Int,
        completion: @escaping ([News]) -> Void
    ) {
        isCalledRequest = true
        
        if error == nil {
            completion([])
        }
    }
}
