//
//  User.swift
//  RealmScreen
//
//  Created by Fedya on 10/27/19.
//  Copyright © 2019 Fedya. All rights reserved.
//

import Foundation

struct User: Decodable {
    let name: UserName
    let id: UserID
    let avatar: Avatar
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case id = "login"
        case avatar = "picture"
    }
}




