//
//  ToDoListViewController+UISearchBarDelegate.swift
//  ToDoTrackr
//
//  Created by Admin on 07.02.18.
//  Copyright © 2018 Ionut-Catalin Bolea. All rights reserved.
//

import UIKit
import CoreData

extension ToDoListViewController : UISearchBarDelegate {
    
    //MARK: - search bar delegates
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let searchRequest : NSFetchRequest<ToDoListItemModel> = ToDoListItemModel.fetchRequest()
        
        let searchPredicate = NSPredicate(format: "listItemEntry CONTAINS[cd] %@", searchBar.text!)
        
        searchRequest.sortDescriptors = [NSSortDescriptor(key: "listItemEntry", ascending: true)]
        
        loadUserData(with: searchRequest, andPredicate: searchPredicate)
        
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
