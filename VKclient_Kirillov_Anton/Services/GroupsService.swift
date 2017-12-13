//
//  GroupsService.swift
//  VKclient_Kirillov_Anton
//
//  Created by Антон Кириллов on 27.09.17.
//  Copyright © 2017 Barpost. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import RealmSwift

extension APIService {
    
    func joinGroup(_ groupID : String, completion: @escaping ( ) -> Void) {
        let parameters: Parameters = [
            "access_token" : APIService.shared.accessToken,
            "group_id"     : groupID,
            "v"            : APIService.Const.version
        ]
        
        let url = APIService.Const.baseURLMethod + APIService.Const.joinGroup
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON(queue: .global(qos: .userInteractive)) { response in
            switch response.result {
            case .failure(let error):
                print(error)
            case .success:
                let responseVK = response.value as! [String: Any]
                _ = responseVK["response"] as? Int ?? 0
                completion()
            }
        }
    }
    
    func leaveGroup( _ groupID: String, completion: @escaping ( ) -> Void) {
        let parameters: Parameters = [
            "access_token" : APIService.shared.accessToken,
            "group_id" : groupID,
            "v" : APIService.Const.version
        ]
        let url = APIService.Const.baseURLMethod + APIService.Const.leaveGroup
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON(queue: .global(qos: .userInteractive)) { response in
            switch response.result {
            case .failure(let error):
                print(error)
            case .success:
                let responseVK = response.value as! [String: Any]
                _ = responseVK["response"] as? Int ?? 0
                completion()
            }
        }
    }
            
    func getUserGroup(user: String) {
        let parameters: Parameters = [
                        "count" : "99",
                        "v" : APIService.Const.version,
                        "access_token" : APIService.shared.accessToken,
                        "user_id" : user,
                        "extended" : "1"
            ]
        let url = APIService.Const.baseURLMethod + APIService.Const.getGroups
        let request = Alamofire.request(
            url,
            method: .get,
            parameters: parameters
            )
        request.responseJSON(queue: .global(qos: .userInteractive)) { respons in
            guard let data = respons.data else {
                return
            }
            let json = JSON(data)
            let userGroups = json["response"]["items"].flatMap { UserGroupInfo(userGroup: $0.1, user: user) }
            self.saveUserGroupData(userGroups, user: user)
        }
    }
    
    func saveUserGroupData(_ userGroups: [UserGroupInfo], user: String) {
        do {
            let realm = try Realm()
            let oldUser = realm.objects(UserGroupInfo.self).filter("user == %@", user)
            realm.beginWrite()
            realm.delete(oldUser)
            realm.add(userGroups, update: false)
            try realm.commitWrite()
        } catch {
            print(error)
        }
    }
    
    func searchGroups(byName: String, completion: @escaping ([GroupInfo]) -> Void) {
        var groupsId = ""
        var parameters: Parameters = [
            "q" : byName,
            "v" : APIService.Const.version,
            "count" : "10",
            "access_token" : APIService.shared.accessToken
        ]
        var url = APIService.Const.baseURLMethod + APIService.Const.searchGroup
        let request = Alamofire.request(url, method: .get, parameters: parameters )
        request.responseJSON { respons in
            guard let data = respons.data else {
                return
            }
            let json = JSON(data)
            let items = json["response"]["items"]
            let number = items.count
            for element in 0...number {
                let allGroup = items[element]
                let ID = allGroup["id"].stringValue
                groupsId = groupsId + "," + ID
                //["id1", "id2"].joined(separator: ",")
            }
            parameters.removeAll()
            parameters = [
                "access_token" : APIService.shared.accessToken, 
                "group_ids" : groupsId,
                "fields" : "members_count",
                "v" : APIService.Const.version
            ]
            url = APIService.Const.baseURLMethod + APIService.Const.getGroupsById
            let requestNew = Alamofire.request(url, method: .get, parameters: parameters)
            requestNew.responseJSON { respons in
                guard let data = respons.data else {
                    return
                }
                let json = JSON(data)
                let items = json["response"].flatMap { GroupInfo(allGroup: $0.1) }
                completion(items)
            }
        }
    }

}



