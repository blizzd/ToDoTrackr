//
//  ToDoListViewController+UISearchBarDelegate.swift
//  ToDoTrackr
//
//  Created by Admin on 07.02.18.
//  Copyright © 2018 Ionut-Catalin Bolea. All rights reserved.
//

import UIKit

extension ToDoListViewController : UISearchBarDelegate {
    
    //MARK: - search bar delegates
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        toDoItems = toDoItems?
            .filter("listItemEntry CONTAINS[cd] %@", searchBar.text!)
            .sorted(byKeyPath: "dateCreated", ascending: false)
        
        loadUserData()
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadUserData()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    
}
