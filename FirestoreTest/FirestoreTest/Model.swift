//
//  Model.swift
//  FirestoreTest
//
//  Created by 김태훈 on 2021/02/18.
//

import Foundation

struct User: Codable {
    var name: String
    var puppies: [Puppy]?
}

struct Puppy: Codable {
    var name: String
    var age: String
    var weight: Double
    var species: String
    var record: [Record]?
}

struct Record: Codable {
    let timeStamp: Date
}
