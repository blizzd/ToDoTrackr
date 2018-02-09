//
//  ToDoCategoryModel.swift
//  ToDoTrackr
//
//  Created by Admin on 09.02.18.
//  Copyright © 2018 Ionut-Catalin Bolea. All rights reserved.
//

import Foundation
import RealmSwift

class ToDoCategoryModel: Object {
    @objc dynamic var categoryName: String = ""
    
    let toDoItems = List<ToDoListItemModel>()
    
}
