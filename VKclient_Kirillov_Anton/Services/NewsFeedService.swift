//
//  NewsFeedService.swift
//  VKclient_Kirillov_Anton
//
//  Created by Антон Кириллов on 16.10.2017.
//  Copyright © 2017 Barpost. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import RealmSwift
import WatchConnectivity


extension APIService {
    
    func getPosts(user: String, completion: @escaping ([Post]) -> Void) {
        let parameters: Parameters = [
            "user_id" : user,
            "v" : APIService.Const.version,
            "access_token" : APIService.shared.accessToken, 
            "filters" : "post",
            "count" : "150"
        ]
        let url = APIService.Const.baseURLMethod + APIService.Const.getNewsFeed
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
            let newsFeed = json["response"]["items"].arrayValue
            let userNews = json["response"]["profiles"].arrayValue
            let groupNews = json["response"]["groups"].arrayValue
            var newsText = [String]()
            var newsImages = [String: String]()
            var newsImagesRatio = [String: Double]()
            let items: [Post] = newsFeed.map {
                let postID = $0["post_id"].stringValue
                let whosePostID = $0["source_id"].intValue
                let dateOfPost = $0["date"].doubleValue
                let textOfPost = $0["text"].stringValue
                var photoWhosePost = ""
                var nameWhosePost = ""
                var whoseRepostID = 0
                if whosePostID > 0 {
                    let user = userNews.filter { $0["id"].intValue == whosePostID }
                    photoWhosePost = user[0]["photo_100"].stringValue
                    nameWhosePost = ("\(user[0]["first_name"]) \(user[0]["last_name"])")
                } else if whosePostID < 0 {
                    let group = groupNews.filter { $0["id"].intValue == abs(whosePostID) }
                    photoWhosePost = group[0]["photo_100"].stringValue
                    nameWhosePost = group[0]["name"].stringValue
                }
                var textOfRepost = ""
                var whoseRepostPhoto = ""
                var whoseRepostName = ""
                var dateOfRepost = 0.0
                var typeOfAttachments = ""
                var IMG = ""
                var RAT = 0.0
                var imageOfPost = [String]()
                var ratioOfImage = [String: Double]()
                var videoID = [String]()
                var ownerVideoID = [String: String]()
                var imageOfVideo = [String: String]()
                var nameOfVideo = [String: String]()
                var videoPlayer = [String: String]()
                var videoKey = [String: String]()
                var audioID = 0
                var nameOfSong = ""
                var artistOfSong = ""
                var audioURL = ""
                var nameOfLink = [String]()
                var linkURL = [String: String]()
                let geoCoord = $0["geo"]["coordinates"].stringValue
                let geoTitle = $0["geo"]["place"]["title"].stringValue
                let likesOfPost = $0["likes"]["count"].stringValue
                let commentsOfPost = $0["comments"]["count"].stringValue
                let repostsOfPost = $0["reposts"]["count"].stringValue
                let watchsOfPost = $0["views"]["count"].stringValue
                if $0["attachments"].isEmpty {
                    whoseRepostID = $0["copy_history"][0]["owner_id"].intValue
                    textOfRepost = $0["copy_history"][0]["text"].stringValue
                    dateOfRepost = $0["copy_history"][0]["date"].doubleValue
                    if whoseRepostID > 0 {
                        let user = userNews.filter { $0["id"].intValue == whoseRepostID }
                        whoseRepostPhoto = user[0]["photo_100"].stringValue
                        whoseRepostName = ("\(user[0]["first_name"]) \(user[0]["last_name"])")
                    } else if whoseRepostID < 0 {
                        let group = groupNews.filter { $0["id"].intValue == abs(whoseRepostID) }
                        whoseRepostPhoto = group[0]["photo_100"].stringValue
                        whoseRepostName = group[0]["name"].stringValue
                    }
                    for item in $0["copy_history"][0]["attachments"].arrayValue {
                        typeOfAttachments = item["type"].stringValue
                        if typeOfAttachments == "photo" {
                            imageOfPost.append(item["photo"]["photo_604"].stringValue)
                            ratioOfImage[item["photo"]["photo_604"].stringValue] = (item["photo"]["width"].doubleValue / item["photo"]["height"].doubleValue)
                        } else if typeOfAttachments == "video" {
                            videoID.append(item["video"]["id"].stringValue)
                            ownerVideoID[item["video"]["id"].stringValue] = item["video"]["owner_id"].stringValue
                            imageOfVideo[item["video"]["id"].stringValue] = item["video"]["photo_320"].stringValue
                            nameOfVideo[item["video"]["id"].stringValue] = item["video"]["title"].stringValue
                            videoPlayer[item["video"]["id"].stringValue] = item["video"]["player"].stringValue
                            videoKey[item["video"]["id"].stringValue] = item["video"]["access_key"].stringValue
                        } else if typeOfAttachments == "audio" {
                            audioID = item["audio"]["id"].intValue
                            nameOfSong = item["audio"]["title"].stringValue
                            artistOfSong = item["audio"]["artist"].stringValue
                            audioURL = item["audio"]["url"].stringValue
                        } else if typeOfAttachments == "link" {
                            nameOfLink.append(item["link"]["title"].stringValue)
                            linkURL[item["link"]["title"].stringValue] = item["link"]["url"].stringValue
                        }
                    }
                } else {
                    for item in $0["attachments"].arrayValue {
                        typeOfAttachments = item["type"].stringValue
                        if typeOfAttachments == "photo" {
                            imageOfPost.append(item["photo"]["photo_604"].stringValue)
                            ratioOfImage[item["photo"]["photo_604"].stringValue] = (item["photo"]["width"].doubleValue / item["photo"]["height"].doubleValue)
                            IMG = item["photo"]["photo_604"].stringValue
                            RAT = (item["photo"]["width"].doubleValue / item["photo"]["height"].doubleValue)
                            defaults?.set(item["photo"]["photo_604"].stringValue, forKey: "imageOfPost")
                        } else if typeOfAttachments == "video" {
                            videoID.append(item["video"]["id"].stringValue)
                            ownerVideoID[item["video"]["id"].stringValue] = item["video"]["owner_id"].stringValue
                            imageOfVideo[item["video"]["id"].stringValue] = item["video"]["photo_320"].stringValue
                            nameOfVideo[item["video"]["id"].stringValue] = item["video"]["title"].stringValue
                            videoPlayer[item["video"]["id"].stringValue] = item["video"]["player"].stringValue
                            videoKey[item["video"]["id"].stringValue] = item["video"]["access_key"].stringValue
                        } else if typeOfAttachments == "audio" {
                            audioID = item["audio"]["id"].intValue
                            nameOfSong = item["audio"]["title"].stringValue
                            artistOfSong = item["audio"]["artist"].stringValue
                            audioURL = item["audio"]["url"].stringValue
                        } else if typeOfAttachments == "link" {
                            nameOfLink.append(item["link"]["title"].stringValue)
                            linkURL[item["link"]["title"].stringValue] = item["link"]["url"].stringValue
                        }
                    }
                }
                let post = Post(
                    postID: postID,
                    avatarImage: photoWhosePost,
                    nameOfAvatar: nameWhosePost,
                    dateOfPost: dateOfPost,
                    whosePostID: whosePostID,
                    typeOfAttachments: typeOfAttachments,
                    textOfPost: textOfPost,
                    whoseRepostID: whoseRepostID,
                    fromWhoRepostImage: whoseRepostPhoto,
                    fromWhoRepostName: whoseRepostName,
                    fromWhoRepostDate: dateOfRepost,
                    textOfRepost: textOfRepost,
                    imageOfPost: imageOfPost,
                    ratioOfImage: ratioOfImage,
                    videoID: videoID,
                    ownerVideoID: ownerVideoID,
                    imageOfVideo: imageOfVideo,
                    nameOfVideo: nameOfVideo,
                    videoPlayer: videoPlayer,
                    videoKey: videoKey,
                    audioID: audioID,
                    nameOfSong: nameOfSong,
                    artistOfSong: artistOfSong,
                    audioURL: audioURL,
                    nameOfLink: nameOfLink,
                    linkURL: linkURL,
                    geoTitle: geoTitle,
                    geoCoord: geoCoord,
                    likesOfPost: likesOfPost,
                    commentsOfPost: commentsOfPost,
                    repostsOfPost: repostsOfPost,
                    watchsOfPost: watchsOfPost
                )
                if textOfPost != "" {
                    newsText.append(textOfPost)
                    newsImages[textOfPost] = IMG
                    newsImagesRatio[IMG] = RAT
                }
//                if (nameOfLink != "") && (textOfPost == "") {
//                    newsText.append(nameOfLink)
//                }
                return post
            }
            DispatchQueue.main.async {
                completion(items)
                self.connectivityHandler = (UIApplication.shared.delegate as? AppDelegate)?.connectivityHandler
                if self.connectivityHandler.session.isPaired && self.connectivityHandler.session.isWatchAppInstalled {
                    self.connectivityHandler.session.sendMessage(["news" : newsText], replyHandler: nil)
                    { (error) in
                        print("\(error)")
                    }
                }
            }
            defaults?.set(newsText, forKey: "arrayOfNewsText")
            defaults?.set(newsImages, forKey: "dictOfImages")
            defaults?.set(newsImagesRatio, forKey: "dictOfImagesRatio")
            defaults?.synchronize()
        }
    }
}
