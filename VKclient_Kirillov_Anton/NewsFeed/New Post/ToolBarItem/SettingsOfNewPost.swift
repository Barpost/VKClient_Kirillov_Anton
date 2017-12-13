//
//  SettingsOfNewPost.swift
//  VKclient_Kirillov_Anton
//
//  Created by Антон Кириллов on 16.11.2017.
//  Copyright © 2017 Barpost. All rights reserved.
//

import UIKit

class SettingsOfNewPost: UIViewController {
    
    @IBOutlet weak var onlyForFriendsSwitchOutlet: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if userDefaults.integer(forKey: "onlyForFriends") == 1 {
            onlyForFriendsSwitchOutlet.isOn = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override var prefersStatusBarHidden: Bool { return true }
    
    @IBAction func onlyForFriendsSwitch(_ sender: UISwitch) {
        if sender.isOn {
            userDefaults.set(1, forKey: "onlyForFriends")
        } else {
            userDefaults.set(0, forKey: "onlyForFriends")
        }
    }
}
