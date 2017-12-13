//
//  AddFriendsTableViewController.swift
//  VKclient_Kirillov_Anton
//
//  Created by Антон Кириллов on 21.11.2017.
//  Copyright © 2017 Barpost. All rights reserved.
//

import UIKit
import RealmSwift

class AddFriendsTableViewController: UITableViewController {
    
    var friends: Results<FriendInfo>?
    var items = [Video]()
    var token: NotificationToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pairTableAndRealm()
        APIService.shared.getFriends(whoseFriends: userDefaults.string(forKey: "userID")!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddFriendsCell", for: indexPath) as! AddFriendsTableViewCell
        tableView.rowHeight = 80
        cell.configure(withFriendInfo: friends![indexPath.row])
        return cell
    }
    func pairTableAndRealm() {
        guard let realm = try? Realm() else { return }
        friends = realm.objects(FriendInfo.self)
        token = friends?.observe { [weak self] (changes: RealmCollectionChange) in
            guard let tableView = self?.tableView else { return }
            switch changes {
            case .initial:
                tableView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                tableView.beginUpdates()
                tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }), with: .none)
                tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}), with: .none)
                tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }), with: .none)
                tableView.endUpdates()
            case .error(let error):
                fatalError("\(error)")
                break
            }
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "unwindFromAddFriendToNewPost", sender: nil)
    }
}
