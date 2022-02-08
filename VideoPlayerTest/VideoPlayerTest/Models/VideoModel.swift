//
//  VideoModel.swift
//  VideoPlayerTest
//
//  Created by MA2103 on 2022/01/10.
//

import Foundation

struct VideoModel: Decodable {
    let title: String
    let thumb: String
    let sources: [String]
    let description: String
    let subtitle: String
}

struct TimeLine {
    let title: String
    let timeStamp: Int
}
