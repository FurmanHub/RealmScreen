//
//  User+Response.swift
//  RealmScreen
//
//  Created by Fedya on 10/28/19.
//  Copyright © 2019 Fedya. All rights reserved.
//

import Foundation

extension User {
    struct Response: Decodable {
        let results: [User]
    }
}
