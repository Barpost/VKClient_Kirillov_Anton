//
//  Friends.swift
//  VKclient_Kirillov_Anton
//
//  Created by Антон Кириллов on 27.09.17.
//  Copyright © 2017 Barpost. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift


class FriendInfo: Object {
    @objc dynamic var friendID: String = ""
    @objc dynamic var firstname: String = ""
    @objc dynamic var lastname: String = ""
    @objc dynamic var image: String = ""
    @objc dynamic var whoseFriends = ""
    
    convenience init(friend: JSON, whoseFriends: String) {
        self.init()
        self.friendID = friend["id"].stringValue
        self.firstname = friend["first_name"].stringValue
        self.lastname = friend["last_name"].stringValue
        self.image = friend["photo_200"].stringValue
        self.whoseFriends = whoseFriends
    }

    override static func primaryKey() -> String {
        return "friendID"
    }
    
}
class FriendImage {
    var friendPhoto: String = ""
    init(photo: JSON) {
        self.friendPhoto = photo["photo_1280"].stringValue
    }
}

