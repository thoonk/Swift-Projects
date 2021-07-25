//
//  ViewController.swift
//  CoreDataTest
//
//  Created by 김태훈 on 2021/07/18.
//

import UIKit
import CoreData

class ItemViewController: UITableViewController {
    // MARK: - Properties
    private let context = (UIApplication.shared.delegate as! AppDelegate
    ).persistentContainer.viewContext
    private var itemArr = [Item]()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItems()
    }
    
    // MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        itemArr.count
    }
    
    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "itemCell",
            for: indexPath
        ) as UITableViewCell
        let item = itemArr[indexPath.row]
        cell.textLabel?.text = item.title
        cell.textLabel?.font = cell.textLabel?.font.withSize(20)
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        itemArr[indexPath.row].done = !itemArr[indexPath.row].done
        
        saveItems()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(
            style: .destructive, title: ""
        ) { [weak self] contextualAction, view, isSuccess in
            
            self?.context.delete((self?.itemArr[indexPath.row])!)
            self?.itemArr.remove(at: indexPath.row)
            self?.saveItems()
        }
        
        deleteAction.backgroundColor = UIColor.init(
            red: 0/255.0,
            green: 0/255.0,
            blue: 0/255.0,
            alpha: 0.0
        )
        
        let deleteIcon = UIImage(systemName: "delete.left")?.withTintColor(
            UIColor.red,
            renderingMode: .alwaysOriginal
        )
        deleteAction.image = deleteIcon
        
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteAction])
        return swipeActions
    }
    
    // MARK: - Actions
    @IBAction func addBtnTapped(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(
            title: "새로운 항목 추가",
            message: "",
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: "추가", style: .default) { action in
            let newItem = Item(context: self.context)
            newItem.title = textField.text ?? "no title"
            newItem.done = false
            
            self.itemArr.append(newItem)
            self.saveItems()
        }
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "제목을 입력하세요."
            textField = alertTextField
        }
        
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Methods
    private func saveContacts() {
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
    
    private func loadContacts() {
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
    
    private func saveItems() {
        do {
            try context.save()
        } catch {
            print("Error Saving Items: \(error.localizedDescription)")
        }
        
        self.tableView.reloadData()
    }
    
    private func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest()) {
        do {
            self.itemArr = try context.fetch(request)
        } catch {
            print("Error fetching data \(error.localizedDescription)")
        }
        tableView.reloadData()
    }
}

// MARK: - UISearchBarDelegate
extension ItemViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // data 타입(Item)을 지정해줘야 컴파일 에러가 발생하지 않음
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request)
    }
}
