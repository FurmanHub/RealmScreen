//
//  ViewController.swift
//  RealmScreen
//
//  Created by Fedya on 10/27/19.
//  Copyright © 2019 Fedya. All rights reserved.
//

import UIKit
import Realm
import RealmSwift
import Kingfisher

class UsersVC: UIViewController {
    
    // MARK: - Outlets

    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Private properties
    
    let viewModel = UsersVM()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupTable()
        fetchLocalUsers()
    }
    
    // MARK: - Private methods
    
    private func setupTable() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 60
        viewModel.tableView = tableView
    }
    
    private func setupNavigationBar() {
        let reloadImage = UIImage(named: "add")
        let addButton = UIBarButtonItem(image: reloadImage, style: .plain, target: self, action: #selector(addNewUsers))
        navigationItem.rightBarButtonItem = addButton
        
        let deleteButton = UIBarButtonItem(title: "Delete All", style: .plain, target: self, action: #selector(deleteAllUsers))
        navigationItem.leftBarButtonItem = deleteButton
    }
    
    private func fetchLocalUsers() {
        viewModel.fetchLocalUsers()
    }
    
    // MARK: - Actions

    @objc private func addNewUsers() {
        viewModel.addNewUsers()
    }
    
    @objc private func deleteAllUsers() {
        viewModel.deleteAllUsers()
    }
}

extension UsersVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            guard let user = viewModel.users?[indexPath.item] else { return }
            viewModel.deleteUser(user: user)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.users?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = viewModel.users?[indexPath.row].fullName
        cell.imageView?.kf.indicatorType = .activity
        cell.imageView?.kf.setImage(with: viewModel.users?[indexPath.row].avatarURL,
                                    options: [.transition(.fade(0.3))],
                                    completionHandler: { [weak self] _ in
            self?.tableView.beginUpdates()
            self?.tableView.endUpdates()
        })
        return cell
    }
}

