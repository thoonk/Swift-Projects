//
//  Encodable.swift
//  FirestoreTest
//
//  Created by 김태훈 on 2021/02/18.
//

import Foundation

enum FIRError: Error {
    case encodingError
}

extension Encodable {
    
    public func toJson() throws -> [String: Any] {
        let objectData = try JSONEncoder().encode(self)
        let jsonObject = try JSONSerialization.jsonObject(with: objectData, options: [])
        guard let json = jsonObject as? [String: Any] else { throw FIRError.encodingError }
        print("JSON: \(json)")
        return json
    }
}
