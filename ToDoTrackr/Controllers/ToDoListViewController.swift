//
//  ToDoListViewController.swift
//  ToDoTrackr
//
//  Created by Admin on 16.01.18.
//  Copyright © 2018 Ionut-Catalin Bolea. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class ToDoListViewController: SwipeTableViewController{
    
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
        
    }
    
    //called before the view appears in the nav stack
    override func viewWillAppear(_ animated: Bool) {
        
        guard let colorHex = selectedCategory?.categoryColor else { fatalError() }
        
        updateNavigationBar(withHexCode: colorHex)
        
        title = selectedCategory!.categoryName
        
    }
    
    //called before the view will disappear from the nav stack
    override func viewWillDisappear(_ animated: Bool) {
       
    }
    
    //update the color before moving the view
    
    override func willMove(toParent parent: UIViewController?) {
        guard let originalColor = UIColor.flatSkyBlue().hexValue() else { fatalError() }
        
        updateNavigationBar(withHexCode: originalColor)
    }
    
    //MARK: - Nav Bar Setup
    
    func updateNavigationBar(withHexCode hexCode:String) {
        guard let currentNavBar = navigationController?.navigationBar else {
            fatalError("Navigation controller does not exist")
        }
        
        guard let navBarColor = UIColor(hexString: hexCode) else { fatalError() }
        
        let contrastNavColor = UIColor(contrastingBlackOrWhiteColorOn: navBarColor, isFlat: true)!
        
        currentNavBar.barTintColor = navBarColor
        currentNavBar.tintColor = contrastNavColor
        
        if #available(iOS 11.0, *) {
            currentNavBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : contrastNavColor]
        } else {
            currentNavBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : contrastNavColor]
        }
        
        searchBar.barTintColor = navBarColor
    }
    
    //MARK - Tableview Datasource methods
    //************************************//
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let itemCell = toDoItems?[indexPath.row] {
            
            cell.textLabel?.text = itemCell.listItemEntry
            
            if let cellColor = UIColor(hexString: selectedCategory?.categoryColor)?.darken(byPercentage:
                CGFloat(indexPath.row) / CGFloat(toDoItems?.count ?? 1)
                ) {
                cell.backgroundColor = cellColor
                cell.textLabel?.textColor = UIColor(contrastingBlackOrWhiteColorOn: cellColor, isFlat: true)
            }
            
            cell.accessoryType = itemCell.checkedItem == true ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items Added"
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
    override func updateModel(at indexPath: IndexPath) {
        do {
            try self.realm.write {
                if let toDoItem = self.toDoItems?[indexPath.row] {
                    self.realm.delete(toDoItem)
                }
            }
        } catch {
            print("Error removing an item \(error)")
        }
    }
    
    func loadUserData() {
        toDoItems = selectedCategory?.toDoItems.sorted(byKeyPath: "listItemEntry", ascending: true)
        tableView.reloadData()
    }
    
}

