//
//  FriendsService.swift
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
        func getFriends(whoseFriends: String){
            let parameters: Parameters = [
                "count" : "4999",
                "user_id" : whoseFriends,
                "access_token" : APIService.shared.accessToken,
                "v" : APIService.Const.version,
                "fields" : "photo_200"
            ]
            let url = APIService.Const.baseURLMethod + APIService.Const.getUserFrends
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
                let friends = json["response"]["items"].flatMap { FriendInfo(friend: $0.1, whoseFriends: whoseFriends) }
                self.saveUserFriendsData(friends, whoseFriends: whoseFriends)
            }
        }
    func saveUserFriendsData(_ friends: [FriendInfo], whoseFriends: String) {
        do {
            let realm = try Realm()
            let oldWhoseFriends = realm.objects(FriendInfo.self).filter("whoseFriends == %@", whoseFriends)
            realm.beginWrite()
            realm.delete(oldWhoseFriends)
            realm.add(friends, update: false)
            try realm.commitWrite()
        } catch {
            print(error)
        }
    }
    
    func getPhotos(whosePhoto: String, completion: @escaping ([FriendImage]) -> Void){
        let parameters: Parameters = [
            "owner_id" : whosePhoto,
            "extended" : "0",
            "photo_sizes" : "0",
            "count" : "100",
            "no_service_albums" : "0",
            "access_token" : APIService.shared.accessToken,
            "v" : APIService.Const.version
        ]
        let url = APIService.Const.baseURLMethod + APIService.Const.getFriendPhotos
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
            let friendPhoto = json["response"]["items"].flatMap { FriendImage(photo: $0.1 ) }
            completion(friendPhoto)
        }
    }
    
    func getFriendsRequests() {
        let parameters: Parameters = [
            "count": "100",
            "extended": "1",
            "sort": "0",
            "need_viewed": "1",
            "access_token": userDefaults.string(forKey: "accessToken") ?? print("no token")
        ]
        let url = APIService.Const.baseURLMethod + APIService.Const.getFriendRequests
        Alamofire.request(url,
                          method: .get,
                          parameters: parameters).responseJSON(queue: .global(qos: .userInteractive)) { response in
                            guard let responseRequestGet = response.value as! [String: Any]? else { return }
                            let array = responseRequestGet["response"] as! [Any]
                            UserDefaults.setValue(array.count, forKey: "RequestsCount")
                            let requestNotification = Notification.Name("requestNotification")
                            NotificationCenter.default.post(name: requestNotification, object: nil)
        }
    }
    
}
