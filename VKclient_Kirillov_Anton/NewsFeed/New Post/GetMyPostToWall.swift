//
//  GetMyPostToWall.swift
//  VKclient_Kirillov_Anton
//
//  Created by Антон Кириллов on 21.11.2017.
//  Copyright © 2017 Barpost. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON

class GetMyPostToWall: Object {
    
    @objc dynamic var photo = ""
    @objc dynamic var server = ""
    @objc dynamic var hashValue1 = ""
    @objc dynamic var serverUpload_url = ""
    
    
    convenience init(json: JSON) {
        self.init()
        photo = json["photo"].stringValue
        server = json["server"].stringValue
        hashValue1 = json["hash"].stringValue
    }
    
    convenience init(getServerUrl json: JSON) {
        self.init()
        serverUpload_url = json["upload_url"].stringValue
    }
}
