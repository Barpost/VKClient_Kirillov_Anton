//
//  UserGroupsTableViewController.swift
//  VKclient_Kirillov_Anton
//
//  Created by Антон Кириллов on 27.09.17.
//  Copyright © 2017 Barpost. All rights reserved.
//

import UIKit
import RealmSwift

class UserGroupsTableViewController: UITableViewController {
    
    var userGroups: Results<UserGroupInfo>?
    var token: NotificationToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pairTableAndRealm()
        APIService.shared.getUserGroup(user: userDefaults.string(forKey: "userID")!)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userGroups?.count ?? 0
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserGroupsCell", for: indexPath) as! UserGroupsCell
        cell.configure(withUserGroupInfo: userGroups![indexPath.row])
        return cell
    }
    
    func pairTableAndRealm() {
        guard let realm = try? Realm() else { return }
        userGroups = realm.objects(UserGroupInfo.self)
        token = userGroups?.observe { [weak self] (changes: RealmCollectionChange) in
            guard let tableView = self?.tableView else { return }
            
            switch changes {
            case .initial:
                tableView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                tableView.beginUpdates()
                tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }),
                                     with: .none)
                tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}),
                                     with: .none)
                tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }),
                                     with: .none)
                tableView.endUpdates()
            case .error(let error):
                fatalError("\(error)")
                break
            }
        }
    }
    @IBAction func addGroup(segue: UIStoryboardSegue) {
        if segue.identifier == "addGroup" {
            let allGroupsController = segue.source as! AllGroupsTableViewController
            if let indexPath = allGroupsController.tableView.indexPathForSelectedRow {
                let group = allGroupsController.items[indexPath.row]
                if !(userGroups?.contains(where: { $0.groupID == group.groupID } ))! {
                    APIService.shared.joinGroup(group.groupID) {
                    Realm.addDataToRealm(objects: [group])
                    }
                }
            }
        }
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            APIService.shared.leaveGroup(userGroups![indexPath.row].groupID) {
                Realm.deleteDataFromRealm(objects: [self.userGroups![indexPath.row]])
            }
        }
    }
}
