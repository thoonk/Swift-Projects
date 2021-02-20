//
//  FIRStoreRef.swift
//  FirestoreTest
//
//  Created by 김태훈 on 2021/02/18.
//

import Foundation

enum FIRStoreRef {
    case users
    case currentUser
    case puppies
    case puppy(puppyId: String)
    case records(puppyId: String)
    case record(puppyId: String, recordId: String)
}

extension FIRStoreRef {
    var uid: String {
//        guard let currentUser = Auth.auth().currentUser else {
//            return "Unknown User"
//        }
        let currentUser = "user2"
        return currentUser
    }

    var path: String {
        switch self {
        case .users:
            return "users"
        case .currentUser:
            return "users/\(uid)"
        case .puppies:
            return "users/\(uid)/puppies"
        case let .puppy(id):
            return "users/\(uid)/puppies/\(id)"
        case let .records(puppyId):
            return "users/\(uid)/puppies/\(puppyId)/record"
        case let .record(puppyId, recordId):
            return "users/\(uid)/puppies/\(puppyId)/record/\(recordId)"
        }
    }
}
