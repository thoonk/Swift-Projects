//
//  ViewController.swift
//  FirestoreTest
//
//  Created by 김태훈 on 2021/02/05.
//

import UIKit
import FirebaseFirestore
import FirebaseStorage
import Photos

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var uploadBtn: UIButton!

    @IBAction func uploadBtnTapped(_ sender: UIButton) {
        
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    
    private let storage = Storage.storage().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkPermissions()
//        guard let urlString = UserDefaults.standard.value(forKey: "url") as? String,
//              let url = URL(string: urlString) else {
//            return
//        }
        
//        let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
//            guard let data = data, error == nil else {
//                return
//            }
//            DispatchQueue.main.async {
//                let image = UIImage(data: data)
//                self.imageView.image = image
//            }
//        }
//
//        task.resume()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        guard let imageData = image.pngData() else {
            return
        }
        
        let ref = storage.child("images/file.png")
        
        ref.putData(imageData, metadata: nil) { (_, error) in
            guard error == nil else {
                print("Failed to upload")
                return
            }
            
            ref.downloadURL { (url, error) in
                guard let url = url, error == nil else {
                    return
                }
                
                let urlString = url.absoluteString
                
                self.imageView.image = image
                
                print("Download URL: \(urlString)")
                UserDefaults.standard.set(urlString, forKey: "url")
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func checkPermissions() {
        let photoAuthorizedStatus = PHPhotoLibrary.authorizationStatus()
        switch photoAuthorizedStatus {
        case .authorized:
            uploadBtn.isEnabled = true
        case .denied:
            uploadBtn.isEnabled = false
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { (status) in
                switch status {
                case .authorized:
                    print("사진 접근 허가")
                case .denied:
                    DispatchQueue.main.async {
                        self.uploadBtn.isEnabled = false
                    }
                    print("사진 접근 불허")
                default:
                    break
                }
            }
        case .limited:
            print("사진 접근 제한")
        case .restricted:
            print("사진 접근 제한")
        @unknown default:
            fatalError("Unknown Error")
        }
    }
    
    func setTest() {
        
//        registerUserInfo(with: UUID().uuidString)
//        registerPuppyInfo(with: "test1")
//        registerPuppyInfo(with: "test1")
//        fetchUserInfo()
        
        // 사용자 정보 등록
//        let name = "yo"
//        FIRStoreManager.shared.registerUserInfo(data: ["name": name], with: .currentUser)
        
        // 강쥐 산책 기록 등록
//        FIRStoreManager.shared.addRecordToday(with: .record(id: "puppy1"))
        
        // 강쥐 정보 등록
//        let id = "puppy1"
//        let puppy = Puppy(id: id, name: "꼬", age: "2019-02-05", weight: 6, species: "프렌치불독")
//        FIRStoreManager.shared.registerPuppyInfo(for: puppy, with: .puppy(id: id))
        
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
//        FIRStoreManager.shared.fetchAllPuppyInfo(from: .puppies, returning: Puppy.self) { (puppies) in
//            print(puppies)
//        }
        
        // 하나의 강쥐 정보 읽기
//        let id = "puppy2"
//        FIRStoreManager.shared.fetchOnePuppyInfo(id: id, from: .puppy(id: id), returning: Puppy.self) { (puppy) in
//            print(puppy)
//        }
        
        // 산책 기록 등록
//        let record: [String:Any] = ["timestamp": Date(), "walkInterval": 30]
//        FIRStoreManager.shared.addRecordInfo(for: record, with: .records(id: "puppy1"))
//        FIRStoreManager.shared.addRecordInfo(data: record, with: .record(puppyId: "puppy1", recordId: "record1"))
        
        // 산책 기록 읽기
        // FIRTimestamp -> Date 변환 방법 찾아야 함
//        FIRStoreManager.shared.fetchRecordInfo(from: .records(puppyId: "puppy1"), returning: Record.self) { (records) in
//            print(records)
//        }
        
        // 산책 기록 삭제
//        FIRStoreManager.shared.deleteRcordInfo(with: .record(puppyId: "puppy1", recordId: "record2"))
    }
}

