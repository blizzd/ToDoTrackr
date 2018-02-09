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
        
        tableView.rowHeight = 80.0
    }
    
    //MARK: - Table Source
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "swipeCell", for: indexPath) as! SwipeTableViewCell
       
        cell.delegate = self
        
        return cell
    }

    //MARK: - Swipe Cell delegates
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { (action, indexPath) in
            //update after deleting a cell
            self.updateModel(at: indexPath)
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
    
    //MARK: - Update Models
    
    func updateModel(at indexPath:IndexPath) {
        //update model on subclasses
    }
   

}
