//
//  ToDoListViewController.swift
//  ToDoTrackr
//
//  Created by Admin on 16.01.18.
//  Copyright © 2018 Ionut-Catalin Bolea. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController{

    var itemArray = [ToDoListItemModel]()
    var dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("ToDoItems.plist", isDirectory: false)
    
    
    let defaults = UserDefaults.standard
    let TODO_LIST_NAME = "TodoListArray"
    let fileEncoder = PropertyListEncoder()
    let fileDecoder = PropertyListDecoder()
    
    @IBOutlet var todosTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadUserData()
        
        todosTableView.register(UINib(nibName: "ToDoListItemCell", bundle: nil), forCellReuseIdentifier: "toDoListItemCell")
        
    }

    //MARK - Tableview Datasource methods
    //************************************//
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoListItemCell", for: indexPath) as! ToDoListItemCell
        
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
                var cellItem = ToDoListItemModel()
                
                if textArray.isEmpty {
                    
                    cellItem.listItemEntry = "Something new"
                    self.itemArray.append(cellItem)
                    
                } else {
                    textArray.forEach {
                        (text) in
                            cellItem = ToDoListItemModel()
                            cellItem.listItemEntry = String(text.trimmingCharacters(in: .whitespacesAndNewlines))
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
            let encodableData = try fileEncoder.encode(itemArray)
            try encodableData.write(to: dataFilePath!)
        } catch {
            print("Error encoding item array, \(error)")
        }
        
        
        self.tableView.reloadData()
    }
    
    func loadUserData() {
        if let decodableData = try? Data(contentsOf: dataFilePath!) {
            do {
                itemArray = try fileDecoder.decode([ToDoListItemModel].self, from: decodableData)
            } catch {
                print("Error decoding item array, \(error)")
            }
        }
       
    }


}

