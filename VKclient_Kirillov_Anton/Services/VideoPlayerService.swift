//
//  VideoPlayerService.swift
//  VKclient_Kirillov_Anton
//
//  Created by Антон Кириллов on 13.12.2017.
//  Copyright © 2017 Barpost. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import RealmSwift

extension APIService {
    
    func getVideo(ownerID: String, videoID: String, accessKey: String, completion: @escaping ([Video]) -> Void) {
        let parameters: Parameters = [
            "owner_id" : ownerID,
            "videos" : "\(ownerID)_\(videoID)_\(accessKey)",
            "extended": 1,
            "v" : APIService.Const.version,
            "access_token" : APIService.shared.accessToken
        ]
        let url = APIService.Const.baseURLMethod + APIService.Const.getVideo
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
            let items: [Video] = json["response"]["items"].arrayValue.map {
                let videoID = $0["id"].stringValue
                let ownerID = $0["owner_id"].stringValue
                let videoPlayer = $0["player"].stringValue
                let video = Video(videoPlayer: videoPlayer, videoID: videoID, ownerID: ownerID)
                return video
            }
            DispatchQueue.main.async {
                completion(items)
            }
        }
    }
    
}
