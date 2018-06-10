//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Klemen Tušar on 09.06.2018.
//  Copyright © 2018 Klemen Tušar. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {

    // Get the default Realm
    let realm = try! Realm() // looks like a code smell but is apparently perfectly valid according to https://realm.io/docs/swift/latest/
    
    // Results is an auto-updating container so we don't need to append to it anymore! :)
    var categories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
    }
    
    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath) // tap into the parent's cell of the same method
        
        if let category = categories?[indexPath.row] {
            cell.textLabel?.text = category.name
            
            guard let categoryColor = UIColor(hexString: category.color) else { fatalError("Invalid category color!") }
            
            cell.backgroundColor = categoryColor
            
            cell.textLabel?.textColor = ContrastColorOf(categoryColor, returnFlat: true)
        }
        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    //MARK: - Data Manipulation Methods
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving context \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadCategories() {
        categories = realm.objects(Category.self)

        tableView.reloadData()
    }
    
    //MARK: - Delete data from swipe
    override func updateModel(at indexPath: IndexPath) {
        if let category = categories?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(category)
                }
            } catch {
                print("Error deleting category, \(error)")
            }

            // tableView.reloadData() // not required anymore since we use editActionsOptionsForRowAt below which automatically refreshes the tableView data
        }
    }

    //MARK: - Add New Categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
        
        alert.addTextField { (field) in
            field.placeholder = "Create new category"
            textField = field
        }
        
        alert.addAction(UIAlertAction(title: "Add category", style: .default) { (action) in
            // what will happen once the user click the add category button on our UIAlert
            let newCategory = Category()
            newCategory.name = textField.text!
            newCategory.color = UIColor.randomFlat.hexValue()
            
            // save to realm; the categories Results now gets auto-updated!!! :)
            self.save(category: newCategory)
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
}
