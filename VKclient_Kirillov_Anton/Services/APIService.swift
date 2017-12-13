//
//  APIService.swift
//  VKclient_Kirillov_Anton
//
//  Created by Антон Кириллов on 27.09.17.
//  Copyright © 2017 Barpost. All rights reserved.
//

import Foundation
import WebKit
import WatchConnectivity

class APIService {
    struct Const {
        static let baseURLMethod = "https://api.vk.com"
        static let version = "5.69"
        static let getUserFrends = "/method/friends.get"
        static let getFriendPhotos = "/method/photos.getAll"
        static let getFriendRequests = "/method/friends.getRequests"
        static let getGroups     = "/method/groups.get"
        static let getGroupsById = "/method/groups.getById"
        static let joinGroup     = "/method/groups.join"
        static let leaveGroup     = "/method/groups.leave"
        static let searchGroup   = "/method/groups.search"
        static let getNewsFeed = "/method/newsfeed.get"
        static let wallPost = "/method/wall.post"
        static let getWallUploadServer = "/method/photos.getWallUploadServer"
        static let saveWallPhoto = "/method/photos.saveWallPhoto"
        static let getVideo = "/method/video.get"
    }
    
    var accessToken = ""
    
    var connectivityHandler : ConnectivityHandler!

    static let shared: APIService = APIService()
    private init() {}
        
    func getrequest() -> URLRequest{
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "oauth.vk.com"
        urlComponents.path = "/authorize"
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: "6193123"),
            URLQueryItem(name: "display", value: "mobile"),
            URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
            URLQueryItem(name: "scope", value: "274454"),
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "v", value: "5.68")
        ]
        let request = URLRequest(url: urlComponents.url!)
        return request
    }
}
