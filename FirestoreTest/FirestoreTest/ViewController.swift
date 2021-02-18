//
//  ViewController.swift
//  FirestoreTest
//
//  Created by 김태훈 on 2021/02/05.
//

import UIKit
import FirebaseFirestore

class ViewController: UIViewController {
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        registerUserInfo(with: UUID().uuidString)
//        registerPuppyInfo(with: "test1")
//        registerPuppyInfo(with: "test1")
//        fetchUserInfo()
//        FIRStoreManager.shared.registerUserInfo(with: .currentUser)
        
        // 강쥐 산책 기록 등록
//        FIRStoreManager.shared.addRecordToday(with: .record(id: "puppy1"))
        
        // 강쥐 정보 등록
//        let puppy = Puppy(name: "꼬꼬", age: "2019-02-05", weight: 6, species: "불독", record: [])
//        FIRStoreManager.shared.registerPuppyInfo(for: puppy, with: .puppy(id: "puppy2"))
        
        // 사용자 이름 업데이트
//        let name = "user2"
//        FIRStoreManager.shared.updateUserInfo(for: ["name": name], with: .currentUser)
        
        // 강쥐 정보 업데이트
//        let data: [String:Any] = ["name":"꼬꼬",
//                                "age":"2020-01-25",
//                                "weight":6,
//                                "species":"슈나우저"]
//        FIRStoreManager.shared.updatePuppyInfo(for: data, with: .puppy(id: "puppy1"))
        
        // 강쥐 정보 삭제
//        FIRStoreManager.shared.deletePuppyInfo(with: .puppy(id: "puppy2"))
        
        // 모든 강쥐 정보 읽기
//        FIRStoreManager.shared.fetchPuppyInfo(from: .puppies, returning: Puppy.self) { (puppy) in
//            print(puppy)
//        }
    }
}

