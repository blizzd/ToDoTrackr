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
    
    let defaults = UserDefaults.standard
    let TODO_LIST_NAME = "TodoListArray"
    
    @IBOutlet var todosTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let introItem = ToDoListItemModel ()
        introItem.listItemEntry = "Start entering your notes"
        introItem.checkedItem = false
        
        itemArray.append(introItem)
        
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
        
        tableView.cellForRow(at: indexPath)?.accessoryType = itemCell.checkedItem == true ? .checkmark : .none
        
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
            
            self.tableView.reloadData()
        }
        
        alert.addTextField{ (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    


}

