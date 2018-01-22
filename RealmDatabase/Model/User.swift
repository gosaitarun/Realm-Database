//
//  User.swift
//  RealmDatabase
//
//  Created by Tarun on 19/01/18.
//  Copyright © 2018 Tarun. All rights reserved.
//

import Foundation
import RealmSwift

class User: Object {
    dynamic var id = 0
    dynamic var name = ""
    dynamic var bank:Bank?
}
