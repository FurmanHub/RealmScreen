//
//  RealmService.swift
//  RealmScreen
//
//  Created by Fedya on 10/28/19.
//  Copyright © 2019 Fedya. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

protocol RealmServiceDelegate: class {
    func usersListDidChange(changes: RealmCollectionChange<Results<RMUser>>)
}

final class RealmService {
    
    var notificationToken: NotificationToken? = nil
    weak var delegate: RealmServiceDelegate?
    
    init(delegate: RealmServiceDelegate) {
        self.delegate = delegate
        observeUsers()
    }
    
    deinit {
        notificationToken?.invalidate()
    }
    
    func saveUsers(_ users: [User]) {
        DispatchQueue(label: "background").async { 
            let realm = try? Realm()
            users.forEach { user in
                let rmUser = RMUser(value: ["id" : user.id.uuid,
                                            "firstName": user.name.first,
                                            "lastName": user.name.last,
                                            "avatar": user.avatar.medium.absoluteString])
                try? realm?.write {
                    realm?.add(rmUser)
                }
            }
        }
    }
    
    func saveUser(_ user: User) {
        DispatchQueue(label: "background").async {
            let realm = try? Realm()
            let rmUser = RMUser(value: ["id" : user.id.uuid,
                                        "firstName": user.name.first,
                                        "lastName": user.name.last,
                                        "avatar": user.avatar.medium.absoluteString])
            try? realm?.write {
                realm?.add(rmUser)
            }
        }
    }
    
    func getUsers() -> [RMUser]? {
        let realm = try? Realm()
        let result = realm?.objects(RMUser.self)
        guard let userResult = result else { return nil }
        return userResult.map { $0 }
    }
    
    func deleteUser(user: RMUser) {
        let realm = try? Realm()
        try? realm?.write {
            realm?.delete(user)
        }
    }
    
    func deleteAllUsers() {
        let realm = try? Realm()
        try! realm?.write {
            realm?.deleteAll()
        }
    }
    
    private func observeUsers() {
        let realm = try? Realm()
        let results = realm?.objects(RMUser.self)
        notificationToken = results?.observe { [weak self] (changes: RealmCollectionChange) in
            self?.delegate?.usersListDidChange(changes: changes)
        }
    }
}
