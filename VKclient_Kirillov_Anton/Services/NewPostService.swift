//
//  NewPostService.swift
//  VKclient_Kirillov_Anton
//
//  Created by Антон Кириллов on 16.11.2017.
//  Copyright © 2017 Barpost. All rights reserved.
//

import Foundation
import Alamofire
import RealmSwift
import SwiftyJSON

extension APIService {
    
    func newPost(message: String, onlyForFriends: Int, geo: (Double, Double)?, attachments: String?) {
            var parameters: Parameters = [
                "owner_id"     : userDefaults.string(forKey: "userID") ?? print("no user ID"),
                "friends_only" : onlyForFriends,
                "message"      : message,
                "access_token" : APIService.shared.accessToken,
                "v"            : APIService.Const.version
            ]
        if geo != nil {
            parameters["lat"] = geo!.0
            parameters["long"] = geo!.1
        }
        if attachments != nil {
            parameters["attachments"] = attachments
        }
            
            let url = APIService.Const.baseURLMethod + APIService.Const.wallPost
            Alamofire.request(url, method: .get, parameters: parameters).responseJSON(queue: .global(qos: .userInteractive)) { response in
                guard let data = response.value else { return }
                let json = JSON(data)
                if let postID = json["response"]["post_id"].int {
                    print("success \(postID)")
                } else {
                    print("fail")
                }
            }
        }
    
    func saveWallPhotoToVkServer(photo: String, server: String, hash: String, completion: @escaping (String) -> Void) {
        let parameters: Parameters = [
            "access_token": APIService.shared.accessToken,
            "v": APIService.Const.version,
            "photo": photo,
            "server": server,
            "hash": hash
        ]
        let url = APIService.Const.baseURLMethod + APIService.Const.saveWallPhoto
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON(queue: .global(qos: .userInteractive)) { response in
            guard let data = response.value else { return }
            let json = JSON(data)
            DispatchQueue.main.async {
                completion("photo\(json["response"][0]["owner_id"].stringValue)_\(json["response"][0]["id"].stringValue)")
            }
        }
    }
    
    func getWallUploadServer(completion: @escaping (GetMyPostToWall) -> Void) {
        let parameters: Parameters = [
            "access_token": APIService.shared.accessToken, 
            "v": APIService.Const.version
        ]
        let url = APIService.Const.baseURLMethod + APIService.Const.getWallUploadServer
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON(queue: .global(qos: .userInteractive)) { response in
            guard let data = response.value else { return }
            let json = JSON(data)
            let serverUrl = json.flatMap { GetMyPostToWall(getServerUrl: $0.1) }
            DispatchQueue.main.async {
                completion(serverUrl[0])
            }
        }
    }
    
}
