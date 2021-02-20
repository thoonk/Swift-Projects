//
//  Model.swift
//  FirestoreTest
//
//  Created by 김태훈 on 2021/02/18.
//

import Foundation

struct User: Codable {
    var name: String
}

struct Puppy: Codable {
    var id: String
    var name: String
    var age: String
    var weight: Double
    var species: String
}

struct Record: Codable {
    let timeStamp: Date
}
