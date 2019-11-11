//
//  ViewModel.swift
//  RealmScreen
//
//  Created by Fedya on 11/10/19.
//  Copyright © 2019 Fedya. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

final class UsersVM {
    private(set) var users: [RMUser]?
    private var service = UserService()
    
    weak var tableView: UITableView?
    
    init() {
         service.delegate = self
    }
    
    func deleteUser(user: RMUser) {
        service.deleteUser(user: user)
    }
    
    func deleteAllUsers() {
        service.deleteAllUsers()
    }
    
    func addNewUsers() {
        service.fetchUsers(comletion: { [weak self] users in
            self?.service.saveUser(users: users)
        })
    }
    
    func fetchLocalUsers() {
        users = service.fetchLocalUsers()
    }
    
    private func saveUsers(users: [User]) {
        service.saveUser(users: users)
    }
}

extension UsersVM: UserServiceDelegate {
    func usersListDidChange(changes: RealmCollectionChange<Results<RMUser>>) {
        users = service.fetchLocalUsers()
        switch changes {
        case .initial:
            tableView?.reloadData()
        case .update(_, let deletions, let insertions, let modifications):
            tableView?.beginUpdates()
            tableView?.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}),
                                 with: .automatic)
            tableView?.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }),
                                 with: .automatic)
            tableView?.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }),
                                 with: .automatic)
            tableView?.endUpdates()
        case .error:
            break
        }
    }
}
