//
//  MovieSearchResponseModel.swift
//  MovieReview
//
//  Created by thoonk on 2022/01/21.
//

import Foundation

struct MovieSearchResponseModel: Decodable {
    var items: [Movie]
}
