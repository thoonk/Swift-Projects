//
//  ViewController.swift
//  CoreDataTest
//
//  Created by 김태훈 on 2021/07/18.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func saveBtnTapped(_ sender: UIButton) {
        setContact()
    }
    
    @IBAction func fetchBtnTapped(_ sender: UIButton) {
        fetchContact()
    }
    
    private func setContact() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Contact", in: context)
        
        let thoonk = Person(name: "thoonkk", number: "010-1234-5678")
        
        if let entity = entity {
            // NSManagedObject에 값을 세팅해줌.
            let person = NSManagedObject(entity: entity, insertInto: context)
            person.setValue(thoonk.name, forKey: "name")
            person.setValue(thoonk.number, forKey: "number")
            
            do {
                try context.save()
                print("Saved Successful")
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    private func fetchContact() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        do {
            guard let contacts = try context.fetch(Contact.fetchRequest()) as? [Contact]
            else { return }
            
            print("fetched Successful")
            contacts.forEach { contact in
                print(contact.name ?? "", contact.number ?? "")
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}

