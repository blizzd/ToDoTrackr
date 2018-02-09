//
//  ToDoListViewController.swift
//  ToDoTrackr
//
//  Created by Admin on 16.01.18.
//  Copyright © 2018 Ionut-Catalin Bolea. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoListViewController: UITableViewController{

    let realm = try! Realm()
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var toDoItems: Results<ToDoListItemModel>?
    var selectedCategory : ToDoCategoryModel? {
        didSet{
            loadUserData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "ToDoItemCell", bundle: nil), forCellReuseIdentifier: "toDoItemCell")

    }

    //MARK - Tableview Datasource methods
    //************************************//
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoItemCell", for: indexPath) as! ToDoItemCell
        
        if let itemCell = toDoItems?[indexPath.row] {
        
            cell.toDoLabel.text = itemCell.listItemEntry
            cell.accessoryType = itemCell.checkedItem == true ? .checkmark : .none
        } else {
            cell.toDoLabel.text = "No Items Added"
        }
        
        return cell
    }
    
    //MARK - Tableview Delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let itemCell = toDoItems?[indexPath.row] {
            do {
                try realm.write {
                    itemCell.checkedItem = !itemCell.checkedItem
                }
            
            } catch {
                print("Error saving status \(error)")
            }
        }
        tableView.reloadData()
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
            
            if let currentCategory = self.selectedCategory {
            
                //for any valid user input, we take the string and separate it so we can create mutiple entries
                if let textString = textField.text {
                    let textArray = textString.split(separator: ",")
                    
                    if textArray.isEmpty {
                        do {
                            try self.realm.write {
                                let cellItem = ToDoListItemModel()
                                    cellItem.listItemEntry = "Something new"
                                    cellItem.dateCreated = Date()
                                    currentCategory.toDoItems.append(cellItem)
                                self.realm.add(cellItem)
                            }
                        } catch {
                            print("Error saving database, \(error)")
                        }
                        
                        self.tableView.reloadData()
                        
                    } else {
                        textArray.forEach {
                            (text) in
                            do {
                                try self.realm.write {
                                    let cellItem = ToDoListItemModel()
                                        cellItem.listItemEntry = String(text.trimmingCharacters(in: .whitespacesAndNewlines))
                                        cellItem.dateCreated = Date()
                                        currentCategory.toDoItems.append(cellItem)
                                    self.realm.add(cellItem)
                                }
                            } catch {
                                print("Error saving database, \(error)")
                            }
                            
                            self.tableView.reloadData()
                        }
                    }
                }
            }
        }
        
        alert.addTextField{ (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: - Model manipulation
    func saveUserData(_ item: ToDoListItemModel) {
        do {
            try realm.write {
                realm.add(item)
            }
        } catch {
            print("Error saving database, \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadUserData() {
        toDoItems = selectedCategory?.toDoItems.sorted(byKeyPath: "listItemEntry", ascending: true)
        tableView.reloadData()
        
        //TODO: - Set View title when the user lands on a category
        //navigationController?.title = selectedCategory?.categoryName
       
    }

}

