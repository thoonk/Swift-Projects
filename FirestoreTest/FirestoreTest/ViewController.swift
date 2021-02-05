//
//  ViewController.swift
//  FirestoreTest
//
//  Created by 김태훈 on 2021/02/05.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        registerUserInfo(with: UUID().uuidString)
//        registerPuppyInfo(with: "test1")
        registerPuppyInfo(with: "test1")
    }

    func registerUserInfo(with user: String) {
        let userDoc = db.collection("users").document(user)
        userDoc.setData([
            "name" : "끝비"
        ]) { error in
            if let error = error {
                print("Error writing docs: \(error)")
            } else {
                print("Writing Succeded")
            }
        }
    }
    
    func registerPuppyInfo(with user: String) {
        let userDoc = db.collection("users").document(user).collection("puppies").document("puppy1")
        userDoc.setData([
            "name" : "앙꼬",
            "species" : "퍼그",
            "age" : "2019-02-05",
            "weight" : 10
        ]) { error in
            if let error = error {
                print("Error writing docs: \(error)")
            } else {
                print("Writing Succeded")
            }
        }
    }
    
    func createPuppyWalked(with user: String) {
        let userDoc = db.collection("users").document(user).collection("puppies").document("puppy1").collection("record")
        userDoc.addDocument(data: [
            "dayStamp" : Date()
        ]) { error in
            if let error = error {
                print("Error writing docs: \(error)")
            } else {
                print("Writing Succeded")
            }
        }
    }
    
    func fetchUserInfo(with user: String) {
        let userDoc = db.collection("users")
        
        userDoc.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Document does not exist: \(error)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                }
            }
        }
    }
    
    func fetchRecordInfo(with user: String) {
        let userDoc = db.collection("users").document(user).collection("puppies").document("puppy1").collection("record")
        
    }
    
}

