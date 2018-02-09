//
//  SwipeTableViewController.swift
//  ToDoTrackr
//
//  Created by Admin on 09.02.18.
//  Copyright © 2018 Ionut-Catalin Bolea. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    //MARK: - Swipe Cell delegates
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { (action, indexPath) in
            //update after deleting a cell
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
        
        // customize the appearance
        deleteAction.image = UIImage(named: "delete-item")
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        
        var swipeOptions = SwipeTableOptions()
        swipeOptions.expansionStyle = .destructive
        swipeOptions.transitionStyle = .reveal
        
        return swipeOptions
    }
   

}
