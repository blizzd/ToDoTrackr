//
//  ToDoListItemModel.swift
//  ToDoTrackr
//
//  Created by Admin on 06.02.18.
//  Copyright © 2018 Ionut-Catalin Bolea. All rights reserved.
//

import Foundation

class ToDoListItemModel: Codable {
    
    var listItemEntry : String = "Something new"
    var checkedItem : Bool = false
    
    init() {
        
    }
    
    init(itemEntry: String, checked: Bool) {
        listItemEntry = itemEntry
        checkedItem = checked
    }
}
