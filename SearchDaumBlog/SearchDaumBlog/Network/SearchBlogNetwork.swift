//
//  SearchBlogNetwork.swift
//  SearchDaumBlog
//
//  Created by thoonk on 2022/01/04.
//

import Foundation
import RxSwift

enum SearchNetworkError: Error {
    case invalidJSON
    case networkError
}

final class SearchBlogNetwork {
    private let session: URLSession
    let api = SearchBlogAPI()
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func searchBlog(query: String) -> Single<Result<DKBlog, SearchNetworkError>> {
        guard let url = api.searchBlog(query: query).url else {
            return .just(.failure(.invalidJSON))
        }
        
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(
            "KakaoAK 61efa7ee47633aa91ccaa461863b0a70",
            forHTTPHeaderField: "Authorization"
        )
        
        return session.rx.data(request: request as URLRequest)
            .map { data in
                do {
                    let blogData = try JSONDecoder().decode(DKBlog.self, from: data)
                    return .success(blogData)
                } catch {
                    return .failure(.invalidJSON)
                }
            }
            .catch { _ in
                .just(.failure(.networkError))
            }
            .asSingle()
    }
}
