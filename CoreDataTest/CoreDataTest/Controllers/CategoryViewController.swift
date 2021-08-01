//
//  CategoryViewController.swift
//  CoreDataTest
//
//  Created by 김태훈 on 2021/08/01.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    // MARK: - Properties
    private let context = (UIApplication.shared.delegate as! AppDelegate
    ).persistentContainer.viewContext
    private var categories = [Category]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
    }

    @IBAction func addBtnTapped(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(
            title: "새로운 카테고리 추가",
            message: "",
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: "추가", style: .default) { action in
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text ?? "name"
            
            self.categories.append(newCategory)
            self.saveCategories()
        }
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "카테고리 이름을 입력하세요."
            textField = alertTextField
        }
        
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }

    // MARK: - TableView data source Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as UITableViewCell
        let category = categories[indexPath.row]
        
        cell.textLabel?.text = category.name
        
        return cell
    }
    
    // MARK: - TableView Delegate Methods

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.performSegue(withIdentifier: "goToItem", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let itemVC = segue.destination as? ItemViewController else { return }
        
        if let indexPath = tableView.indexPathForSelectedRow {
            itemVC.selectedCategory = categories[indexPath.row]
        }
              
    }
    
    // MARK: - Data Manipulation Methods
    private func saveCategories() {
        do {
            try context.save()
        } catch {
            print("Error Saving Items: \(error.localizedDescription)")
        }
        
        self.tableView.reloadData()
    }
    
    private func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        do {
            self.categories = try context.fetch(request)
        } catch {
            print("Error fetching data \(error.localizedDescription)")
        }
        tableView.reloadData()
    }
}
