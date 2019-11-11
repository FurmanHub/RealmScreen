//
//  RandomUserService.swift
//  RealmScreen
//
//  Created by Fedya on 10/27/19.
//  Copyright © 2019 Fedya. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

protocol UserServiceDelegate: class {
    func usersListDidChange(changes: RealmCollectionChange<Results<RMUser>>)
}

final class UserService {
    
    weak var delegate: UserServiceDelegate?
    private var realmService: RealmService?
    private let session = URLSession.shared
    
    private var baseURL: URL {
        return URL(string: "https://randomuser.me/api/?results=10")!
    }
    
    init() {
        realmService = RealmService(delegate: self)
    }
    
    func fetchUsers(comletion: @escaping (([User]) -> Void)) {
        let task = session.dataTask(with: baseURL, completionHandler: { data, response, error in
            guard let responseData = data else { return }
            guard let usersResponse = try? JSONDecoder().decode(User.Response.self, from: responseData) else { return }
            comletion(usersResponse.results)
        })
        task.resume()
    }
    
    func saveUser(user: User) {
        realmService?.saveUser(user)
    }
    
    func saveUser(users: [User]) {
        realmService?.saveUsers(users)
    }
    
    func fetchLocalUsers() -> [RMUser]? {
        return realmService?.getUsers()
    }
    
    func deleteUser(user: RMUser) {
        realmService?.deleteUser(user: user)
    }
    
    func deleteAllUsers() {
        realmService?.deleteAllUsers()
    }
    
}

extension UserService: RealmServiceDelegate {
    func usersListDidChange(changes: RealmCollectionChange<Results<RMUser>>) {
        delegate?.usersListDidChange(changes: changes)
    }
}
