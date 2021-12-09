//
//  Feature.swift
//  AppStore
//
//  Created by MA2103 on 2021/12/09.
//

import Foundation

struct Feature: Decodable {
    let type: String
    let appName: String
    let description: String
    let imageURL: String
}
