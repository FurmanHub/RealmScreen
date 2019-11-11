//
//  RMUser.swift
//  RealmScreen
//
//  Created by Fedya on 10/28/19.
//  Copyright © 2019 Fedya. All rights reserved.
//

import Foundation
import RealmSwift

class RMUser: Object {
    override static func primaryKey() -> String? { return #keyPath(id) }
    
    @objc dynamic var id: String = ""
    @objc dynamic var firstName: String = ""
    @objc dynamic var lastName: String = ""
    @objc dynamic var avatar: String = ""
}

extension RMUser {
    var fullName: String {
        return firstName + " " + lastName
    }
    
    var avatarURL: URL? {
        return URL(string: avatar)
    }
}
