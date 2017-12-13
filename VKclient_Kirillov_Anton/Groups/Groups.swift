//
//  Groups.swift
//  VKclient_Kirillov_Anton
//
//  Created by Антон Кириллов on 27.09.17.
//  Copyright © 2017 Barpost. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class GroupInfo: Object {
     @objc dynamic var groupID = ""
     @objc dynamic var name = ""
     @objc dynamic var memberCount = ""
     @objc dynamic var image = ""
    
    convenience init(allGroup: JSON) {
        self.init()
        self.groupID = allGroup["id"].stringValue
        self.name = allGroup["name"].stringValue
        self.memberCount = allGroup["members_count"].stringValue
        self.image = allGroup["photo_200"].stringValue
    }
}

class UserGroupInfo: Object {
    @objc dynamic var groupID = ""
    @objc dynamic var name = ""
    @objc dynamic var image = ""
    @objc dynamic var user = ""

    convenience init(userGroup: JSON, user: String) {
        self.init()
        self.groupID = userGroup["id"].stringValue
        self.name = userGroup["name"].stringValue
        self.image = userGroup["photo_200"].stringValue
        self.user = user
    }
    
    override static func primaryKey() -> String {
        return "groupID"
    }
    
}
