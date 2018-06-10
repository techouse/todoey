//
//  Data.swift
//  Todoey
//
//  Created by Klemen Tušar on 10.06.2018.
//  Copyright © 2018 Klemen Tušar. All rights reserved.
//

import Foundation
import RealmSwift

class Data: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var age: Int = 0
}
