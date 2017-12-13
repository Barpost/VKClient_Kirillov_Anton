//
//  AllGroupsTableViewController.swift
//  VKclient_Kirillov_Anton
//
//  Created by Антон Кириллов on 27.09.17.
//  Copyright © 2017 Barpost. All rights reserved.
//

import UIKit
import FirebaseDatabase

class AllGroupsTableViewController: UITableViewController, UISearchBarDelegate {
    @IBOutlet var searchBar: UISearchBar!
    var items = [GroupInfo]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        searchBar.barTintColor = UIColor.lightGray
        searchBar.showsCancelButton = false
        searchBar.placeholder = "Search Bitch!!"
        searchBar.tintColor = UIColor(red: 89/255, green: 125/255, blue: 163/255, alpha: 1)
        self.tableView.tableHeaderView = searchBar
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        DispatchQueue.main.async {
            APIService.shared.searchGroups(byName: (searchText)) { [weak self] items in
                guard let strongSelf = self else { return }
                strongSelf.items = items
                strongSelf.tableView.reloadData()
            }
        }
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = false
        self.searchBar.text = ""
        self.searchBar.resignFirstResponder()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AllGroupsCell", for: indexPath) as! AllGroupsTableViewCell
        cell.configure(withAllGroupInfo: items[indexPath.row])
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        APIService.shared.joinGroup(items[indexPath.row].groupID) { [weak self] in
            self?.performSegue(withIdentifier: "addGroup", sender: nil)
//            let groups = GROUP(groupID: (self?.items[indexPath.row].groupID)!)
//            let dbLink = Database.database().reference()
//            dbLink.child("USER/\(userDefaults.string(forKey: "userID")!)/groups").updateChildValues(["\(groups.groupID)": groups.toAnyObject])
        }
    }
    
    
}

