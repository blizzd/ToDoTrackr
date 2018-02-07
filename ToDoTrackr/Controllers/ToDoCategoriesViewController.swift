//
//  ToDoCategoriesViewController.swift
//  ToDoTrackr
//
//  Created by Admin on 07.02.18.
//  Copyright © 2018 Ionut-Catalin Bolea. All rights reserved.
//

import UIKit
import CoreData

class ToDoCategoriesViewController: UITableViewController {

    let databaseContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var categoryArray = [ToDoCategoryModel]()
    
    @IBOutlet var categoryTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoryTableView.register(UINib(nibName: "ToDoItemCell", bundle: nil), forCellReuseIdentifier: "toDoItemCell")
        
        loadCategoryData()
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoItemCell", for: indexPath) as! ToDoItemCell
        
        let itemCell = categoryArray[indexPath.row]
        
        cell.toDoLabel.text = itemCell.categoryName
        
        return cell
    }
    
    //MARK: - Table view delegates
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToList", sender: self)
        
        categoryTableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationListVC = segue.destination as! ToDoListViewController
        
        if let indexPath = categoryTableView.indexPathForSelectedRow {
            destinationListVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
    
    //MARK: - Data Manipulations
    
    func saveCategoryData() {
        do {
            try databaseContext.save()
        } catch {
            print("Error saving database, \(error)")
        }
        
        
        categoryTableView.reloadData()
    }
    
    func loadCategoryData(with request: NSFetchRequest<ToDoCategoryModel> = ToDoCategoryModel.fetchRequest()) {
        do {
            categoryArray = try databaseContext.fetch(request)
        } catch {
            print("Error loading database, \(error)")
        }
        categoryTableView.reloadData()
        
    }
    
    //MARK: - Add new Categories
    

    @IBAction func addCategoryButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category(-ies)", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category(-ies)", style: .default) {
            (action) in
            //once the user clicks the Add Item, this happens
            print("\(String(describing: textField.text?.split(separator: ",")))")
            
            if let textString = textField.text {
                let textArray = textString.split(separator: ",")
                
                
                if textArray.isEmpty {
                    let cellItem = ToDoCategoryModel(context: self.databaseContext)
                    cellItem.categoryName = "Some new category"
                    self.categoryArray.append(cellItem)
                    
                } else {
                    textArray.forEach {
                        (text) in
                        let cellItem = ToDoCategoryModel(context: self.databaseContext)
                        cellItem.categoryName = String(text.trimmingCharacters(in: .whitespacesAndNewlines))
                        self.categoryArray.append(cellItem)
                    }
                }
            }
            
            self.saveCategoryData()
        }
        
        alert.addTextField{ (alertTextField) in
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
}
