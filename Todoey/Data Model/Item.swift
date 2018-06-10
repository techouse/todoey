//
//  Item.swift
//  Todoey
//
//  Created by Klemen Tušar on 10.06.2018.
//  Copyright © 2018 Klemen Tušar. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date = Date()
    
    // belongsTo relationship
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
