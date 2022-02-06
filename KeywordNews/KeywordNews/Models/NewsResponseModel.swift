//
//  NewsResponseModel.swift
//  KeywordNews
//
//  Created by thoonk on 2022/02/06.
//

import Foundation

struct NewsResponseModel: Decodable {
    var items: [News] = []
}

struct News: Decodable {
    let title: String
    let link: String
    let description: String
    let pubDate: String
}
