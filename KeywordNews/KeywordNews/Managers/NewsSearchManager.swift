//
//  NewsSearchManager.swift
//  KeywordNews
//
//  Created by thoonk on 2022/02/06.
//

import Foundation
import Alamofire

protocol NewsSearchManagerProtocol {
    func request(
        from keyword: String,
        start: Int,
        display: Int,
        completion: @escaping ([News]) -> Void
    )
}

struct NewsSearchManager: NewsSearchManagerProtocol {
    func request(
        from keyword: String,
        start: Int,
        display: Int,
        completion: @escaping ([News]) -> Void
    ) {
        guard let url = URL(string: "https://openapi.naver.com/v1/search/news.json") else { return
        }
        
        let params = NewsRequestModel(query: keyword, start: start, display: display)
        
        let headers: HTTPHeaders = [
            "X-Naver-Client-Id": "vYRM5gM3rCULEZTgiMVN",
            "X-Naver-Client-Secret": "8O_RICmJ1P"
        ]
        
        AF.request(
            url,
            method: .get,
            parameters: params,
            headers: headers
        )
            .responseDecodable(of: NewsResponseModel.self) { response in
                switch response.result {
                case .success(let result):
                    completion(result.items)
                case .failure(let err):
                    print(err)
                }
            }
    }
}
