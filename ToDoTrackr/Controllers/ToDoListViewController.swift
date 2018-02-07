//
//  ToDoListViewController.swift
//  ToDoTrackr
//
//  Created by Admin on 16.01.18.
//  Copyright © 2018 Ionut-Catalin Bolea. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController{

    let databaseContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet var todosTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var itemArray = [ToDoListItemModel]()
    var selectedCategory : ToDoCategoryModel? {
        didSet{
            loadUserData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        todosTableView.register(UINib(nibName: "ToDoItemCell", bundle: nil), forCellReuseIdentifier: "toDoItemCell")

    }

    //MARK - Tableview Datasource methods
    //************************************//
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoItemCell", for: indexPath) as! ToDoItemCell
        
        let itemCell = itemArray[indexPath.row]
        
        cell.toDoLabel.text = itemCell.listItemEntry
        cell.accessoryType = itemCell.checkedItem == true ? .checkmark : .none
        
        return cell
    }
    
    //MARK - Tableview Delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let itemCell = itemArray[indexPath.row]
        
        itemCell.checkedItem = !itemCell.checkedItem
        
        saveUserData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - Add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New ToDo Item(s)", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item(s)", style: .default) {
            (action) in
         //once the user clicks the Add Item, this happens
            print("\(String(describing: textField.text?.split(separator: ",")))")
            
            if let textString = textField.text {
                let textArray = textString.split(separator: ",")
                
                
                if textArray.isEmpty {
                    let cellItem = ToDoListItemModel(context: self.databaseContext)
                    cellItem.listItemEntry = "Something new"
                    cellItem.checkedItem = false
                    cellItem.parentCategory = self.selectedCategory
                    self.itemArray.append(cellItem)
                    
                } else {
                    textArray.forEach {
                        (text) in
                        let cellItem = ToDoListItemModel(context: self.databaseContext)
                            cellItem.listItemEntry = String(text.trimmingCharacters(in: .whitespacesAndNewlines))
                            cellItem.checkedItem = false
                            cellItem.parentCategory = self.selectedCategory
                            self.itemArray.append(cellItem)
                    }
                }
            }
            
            self.saveUserData()
        }
        
        alert.addTextField{ (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: - Model manipulation
    
    func saveUserData() {
        do {
           try databaseContext.save()
        } catch {
            print("Error saving database, \(error)")
        }
        
        
        tableView.reloadData()
    }
    
    func loadUserData(with request: NSFetchRequest<ToDoListItemModel> = ToDoListItemModel.fetchRequest(), andPredicate predicate: NSPredicate? = nil) {
        let categoryPredicate = NSPredicate(format: "parentCategory.categoryName MATCHES %@", selectedCategory!.categoryName!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
        do {
                itemArray = try databaseContext.fetch(request)
            } catch {
                print("Error loading database, \(error)")
            }
        tableView.reloadData()
       
    }

}

