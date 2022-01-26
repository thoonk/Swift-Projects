//
//  Movie.swift
//  MovieReview
//
//  Created by thoonk on 2022/01/21.
//

import Foundation

struct Movie: Decodable {
    let title: String
    private let image: String
    let pubDate: String
    let director: String
    let actor: String
    let userRating: String
    
    var imageURL: URL? { URL(string: image) }
    
    init(
        title: String,
        imageURL: String,
        pubDate: String,
        director: String,
        actor: String,
        userRating: String
    ) {
        self.title = title
        self.image = imageURL
        self.pubDate = pubDate
        self.director = director
        self.actor = actor
        self.userRating = userRating
    }
}
