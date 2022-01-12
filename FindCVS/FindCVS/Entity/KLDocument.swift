//
//  KLDocument.swift
//  FindCVS
//
//  Created by thoonk on 2022/01/12.
//

import Foundation

struct KLDocument: Decodable {
    let placeName: String
    let addressName: String
    let roadAddressName: String
    let x: String
    let y: String
    let distance: String
    
    enum CodingKeys: String, CodingKey {
        case placeName = "place_name"
        case addressName = "address_name"
        case roadAddressName = "road_address_name"
        case x, y, distance
    }
}
