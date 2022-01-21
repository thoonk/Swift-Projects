//
//  MovieSearchManager.swift
//  MovieReview
//
//  Created by thoonk on 2022/01/21.
//

import Alamofire

protocol MovieSearchManagerProtocol {
    func request(from keyword: String, completion: @escaping ([Movie]) -> Void)
}

struct MovieSearchManager: MovieSearchManagerProtocol {
    func request(from keyword: String, completion: @escaping ([Movie]) -> Void) {
        guard let url = URL(string: "https://openapi.naver.com/v1/search/movie.json") else { return }
        let parameters = MoviSearchRequestModel(query: keyword)
        let headers: HTTPHeaders = [
            "X-Naver-Client-Id": "",
            "X-Naver-Client-Secret": ""
        ]
        
        AF.request(
            url,
            method: .get,
            parameters: parameters,
            headers: headers
        )
            .responseDecodable(of: MovieSearchResponseModel.self) { response in
                switch response.result {
                case .success(let result):
                    completion(result.items)
                case .failure(let error):
                    print(error)
                }
            }
            .resume()
    }
}
