//
//  ToDoListItemModel.swift
//  ToDoTrackr
//
//  Created by Admin on 09.02.18.
//  Copyright © 2018 Ionut-Catalin Bolea. All rights reserved.
//

import Foundation
import RealmSwift

class ToDoListItemModel: Object {
    @objc dynamic var listItemEntry : String = ""
    @objc dynamic var checkedItem : Bool = false
    @objc dynamic var dateCreated : Date?
    var parentCategory = LinkingObjects(fromType: ToDoCategoryModel.self, property: "toDoItems")
}
