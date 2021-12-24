//
//  Repository.swift
//  GithubRepository
//
//  Created by MA2103 on 2021/12/24.
//

import Foundation

struct Repository: Decodable {
    let id: Int
    let name: String
    let description: String
    let stargazersCount: Int
    let language: String
    
    enum CodingKeys: String, CodingKey {
        case stargazersCount = "stargazers_count"
        case id, name, description, language
    }
}
