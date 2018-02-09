//
//  ToDoCategoriesViewController.swift
//  ToDoTrackr
//
//  Created by Admin on 07.02.18.
//  Copyright © 2018 Ionut-Catalin Bolea. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit
import ChameleonFramework

class ToDoCategoriesViewController: SwipeTableViewController {

    let realm = try! Realm()
    
    var categoryItems: Results<ToDoCategoryModel>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategoryData()
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        let itemCell = categoryItems?[indexPath.row]
        
        let cellColor = UIColor(hexString: itemCell?.categoryColor ?? UIColor.flatSkyBlue().hexValue())
        
        cell.textLabel?.text = itemCell?.categoryName ?? "No Categories Yet"
        cell.textLabel?.textColor = UIColor(contrastingBlackOrWhiteColorOn: cellColor, isFlat: true)
        
        cell.backgroundColor = cellColor
        
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
    
    //MARK: - Deleta data from Swipe
    
    override func updateModel(at indexPath: IndexPath) {
        do {
            try self.realm.write {
                if let categoryItem = self.categoryItems?[indexPath.row] {
                    self.realm.delete(categoryItem)
                }
            }
        } catch {
            print("Error removing an item \(error)")
        }
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
                    cellItem.categoryColor = UIColor.randomFlat().hexValue()
                    self.saveCategoryData(cellItem)
                    
                } else {
                    textArray.forEach {
                        (text) in
                        let cellItem = ToDoCategoryModel()
                        cellItem.categoryName = String(text.trimmingCharacters(in: .whitespacesAndNewlines))
                        cellItem.categoryColor = UIColor.randomFlat().hexValue()
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
