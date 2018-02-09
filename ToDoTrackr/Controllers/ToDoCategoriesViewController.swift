//
//  ToDoCategoriesViewController.swift
//  ToDoTrackr
//
//  Created by Admin on 07.02.18.
//  Copyright © 2018 Ionut-Catalin Bolea. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoCategoriesViewController: UITableViewController {

    let realm = try! Realm()
    
    var categoryItems: Results<ToDoCategoryModel>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "ToDoItemCell", bundle: nil), forCellReuseIdentifier: "toDoItemCell")
        
        loadCategoryData()
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoItemCell", for: indexPath) as! ToDoItemCell
        
        let itemCell = categoryItems?[indexPath.row]
        
        cell.toDoLabel.text = itemCell?.categoryName ?? "No Categories Yet"
        
        return cell
    }
    
    //MARK: - Table view delegates
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToList", sender: self)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - View transitions
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationListVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationListVC.selectedCategory = categoryItems?[indexPath.row]
        }
    }
    
    //MARK: - Data Manipulations
    
    func saveCategoryData(_ category: ToDoCategoryModel) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving database, \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadCategoryData() {
        categoryItems = realm.objects(ToDoCategoryModel.self)
        tableView.reloadData()
        
    }
    
    //MARK: - Add new Categories
    

    @IBAction func addCategoryButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category(-ies)", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category(-ies)", style: .default) {
            (action) in
            //once the user clicks the Add Item, this happens
            print("\(String(describing: textField.text?.split(separator: ",")))")
            
            //for any valid user input, we take the string and separate it so we can create mutiple categories
            if let textString = textField.text {
                let textArray = textString.split(separator: ",")
                
                
                if textArray.isEmpty {
                    let cellItem = ToDoCategoryModel()
                    cellItem.categoryName = "Some new category"
                    self.saveCategoryData(cellItem)
                    
                } else {
                    textArray.forEach {
                        (text) in
                        let cellItem = ToDoCategoryModel()
                        cellItem.categoryName = String(text.trimmingCharacters(in: .whitespacesAndNewlines))
                        self.saveCategoryData(cellItem)
                    }
                }
            }
        }
        
        alert.addTextField{ (alertTextField) in
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
}
