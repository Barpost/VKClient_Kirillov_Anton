//
//  PostLayoutViewModel.swift
//  VKclient_Kirillov_Anton
//
//  Created by Антон Кириллов on 22.10.2017.
//  Copyright © 2017 Barpost. All rights reserved.
//

import Foundation
import LayoutKit
import YYWebImage

struct Post {
    var postID: String
    // top of post
    var avatarImage: String 
    var nameOfAvatar: String
    var dateOfPost: Double
    var whosePostID: Int
    var typeOfAttachments: String
    // text of post
    var textOfPost: String
    // repost
    var whoseRepostID: Int
    var fromWhoRepostImage: String
    var fromWhoRepostName: String
    var fromWhoRepostDate: Double
    var textOfRepost: String
    // photo of post
    var imageOfPost: [String]
    var ratioOfImage: [String: Double]
    //var heightOfImage: Array
    // video of post
    var videoID: [String]
    var ownerVideoID: [String: String]
    var imageOfVideo: [String: String]
    var nameOfVideo: [String: String]
    var videoPlayer: [String: String]
    var videoKey: [String: String]
    // audio of post
    var audioID: Int
    var nameOfSong: String
    var artistOfSong: String
    var audioURL: String
    // link of post
    var nameOfLink: [String]
    var linkURL: [String: String]
    //geo of post
    var geoTitle: String
    var geoCoord: String
    // bottom of post
    var likesOfPost: String
    var commentsOfPost: String
    var repostsOfPost: String
    var watchsOfPost: String
}

extension Post: Equatable {
    static func ==(lhs: Post, rhs: Post) -> Bool {
        return lhs.postID == rhs.postID
    }
}

final class PostLayout: InsetLayout<View> {
    init(post: Post) {
        
        var children = [Layout]()
        let W = UIScreen.main.bounds.width

        // MARK: - HEAD OF THE POST WHO POST
        let avatarImageLayout = SizeLayout<UIImageView>(
            width: 50,
            height: 50,
            viewReuseId: "post_avatarImage") { imageView in
                imageView.layer.masksToBounds = true
                imageView.layer.cornerRadius = 25
                imageView.yy_setImage(with: URL(string: post.avatarImage), options: .setImageWithFadeAnimation)
                imageView.backgroundColor = UIColor.black.withAlphaComponent(0.1)}
        
        let nameOfAvatarLayout = LabelLayout(
            text: post.nameOfAvatar,
            font: UIFont.systemFont(ofSize: 18),
            viewReuseId: "post_nameOfAvatar") { label in
                label.textColor = UIColor.black.withAlphaComponent(0.9)
                label.backgroundColor = UIColor.white}
        
        let date = Date(timeIntervalSince1970: TimeInterval(post.dateOfPost))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM d, HH:mm"
        dateFormatter.timeZone = TimeZone.current
        let dateOfPost = dateFormatter.string(from: date)
        
        let dateOfPostLayout = LabelLayout(
            text: dateOfPost,
            font: UIFont.systemFont(ofSize: 14),
            viewReuseId: "post_dateOfPost") { label in
                label.textColor = UIColor.black.withAlphaComponent(0.3)
                label.backgroundColor = UIColor.white}
        
        let nameDateStack = StackLayout(
            axis: .vertical,
            spacing: 18,
            sublayouts: [nameOfAvatarLayout, dateOfPostLayout])
        
        let whosePostStack = StackLayout(
            axis: .horizontal,
            spacing: 8,
            sublayouts: [avatarImageLayout, nameDateStack])
        children.append(whosePostStack)
        // MARK: - TEXT OF POST
        let textOfPostLayout = LabelLayout(
            text: post.textOfPost,
            font: UIFont.systemFont(ofSize: 16),
            viewReuseId: "post_textOfPost") { label in
                label.textColor = UIColor.black.withAlphaComponent(0.9)
                label.backgroundColor = UIColor.white}
        
        if post.textOfPost != "" {
            children.append(textOfPostLayout)
        }
        // MARK: - REPOST
        let fromWhoRepostImageLayout = SizeLayout<UIImageView>(
            width: 45,
            height: 45,
            viewReuseId: "post_fromWhoRepostImage") { imageView in
                imageView.layer.masksToBounds = true
                imageView.layer.cornerRadius = 22.5
                imageView.yy_setImage(with: URL(string: post.fromWhoRepostImage), options: .setImageWithFadeAnimation)
                imageView.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        }
        let fromWhoRepostNameLayout = LabelLayout(
            text: "Re: \(post.fromWhoRepostName)",
            font: UIFont.systemFont(ofSize: 18),
            viewReuseId: "post_fromWhoRepostName") { label in
                label.textColor = UIColor.black.withAlphaComponent(0.9)
                label.backgroundColor = UIColor.white
        }
        let dateRepost = Date(timeIntervalSince1970: TimeInterval(post.fromWhoRepostDate))
        let dateOfRepost = dateFormatter.string(from: dateRepost)
        let fromWhoRepostDateLayout = LabelLayout(
            text: dateOfRepost,
            font: UIFont.systemFont(ofSize: 14),
            viewReuseId: "post_fromWhoRepostDate") { label in
                label.textColor = UIColor.black.withAlphaComponent(0.3)
                label.backgroundColor = UIColor.white
        }
        let reNameDateStack = StackLayout(
            axis: .vertical,
            spacing: 8,
            sublayouts: [fromWhoRepostNameLayout, fromWhoRepostDateLayout])
        let whoseRepostStack = StackLayout(
            axis: .horizontal,
            spacing: 8,
            sublayouts: [fromWhoRepostImageLayout, reNameDateStack])
        let textOfRepostLayout = LabelLayout(
            text: post.textOfRepost,
            font: UIFont.systemFont(ofSize: 16),
            viewReuseId: "post_textOfRepost") { label in
            label.textColor = UIColor.black.withAlphaComponent(0.9)
        }
        let rePostStack = StackLayout( //GLOBAL
            axis: .vertical,
            spacing: 8,
            sublayouts: [whoseRepostStack, textOfRepostLayout])
        if post.whoseRepostID != 0 {
            children.append(rePostStack)
        }
        // MARK: - PHOTO OF POST
        var imageU = [Layout]()
        var imageM = [Layout]()
        var imageD = [Layout]()
        if post.imageOfPost.count == 1 {
            let IMG = post.imageOfPost[0]
            let RAT = post.ratioOfImage[IMG]
            let imageOfPostLayout = SizeLayout<UIImageView>(
                width: W,
                height: (W / CGFloat(RAT!)),
                viewReuseId: "post_imageOfPost") { imageView in
                    imageView.layer.masksToBounds = true
                    imageView.layer.cornerRadius = 5
                    imageView.yy_setImage(with: URL(string: IMG), options: .setImageWithFadeAnimation)
                    imageView.backgroundColor = UIColor.black.withAlphaComponent(0.1)
                    imageView.contentMode = UIViewContentMode.scaleToFill
            }
            children.append(imageOfPostLayout)
        } else if post.imageOfPost.count == 2 {
            var image = [Layout]()
            for (_, value) in post.imageOfPost.enumerated() {
                let imageOT = SizeLayout<UIImageView>(
                    width: ((W / 2) - 1),
                    height: (W / 2) ) { imageView in
                        imageView.layer.masksToBounds = true
                        imageView.layer.cornerRadius = 5
                        imageView.yy_setImage(with: URL(string: value), options: .setImageWithFadeAnimation)
                        imageView.backgroundColor = UIColor.black.withAlphaComponent(0.1)
                        imageView.contentMode = UIViewContentMode.scaleAspectFill}
                image.append(imageOT)
            }
            let imageStack = StackLayout(
                axis: .horizontal,
                spacing: 2,
                sublayouts: image)
            children.append(imageStack)
        } else if post.imageOfPost.count == 3 {
            let imageOne = SizeLayout<UIImageView>(
                width: ((2 * (W / 3)) - 1),
                height: (2 * (W / 3)) ) { imageView in
                    imageView.layer.masksToBounds = true
                    imageView.layer.cornerRadius = 5
                    imageView.yy_setImage(with: URL(string: post.imageOfPost[0]), options: .setImageWithFadeAnimation)
                    imageView.backgroundColor = UIColor.black.withAlphaComponent(0.1)
                    imageView.contentMode = UIViewContentMode.scaleAspectFill}
            var imageTT = [Layout]()
            let img = post.imageOfPost.dropFirst()
            for item in img {
                let imageTwoThree = SizeLayout<UIImageView>(
                    width: ((W / 3) - 1),
                    height: ((W / 3) - 1)) { imageView in
                        imageView.layer.masksToBounds = true
                        imageView.layer.cornerRadius = 5
                        imageView.yy_setImage(with: URL(string: item), options: .setImageWithFadeAnimation)
                        imageView.backgroundColor = UIColor.black.withAlphaComponent(0.1)
                        imageView.contentMode = UIViewContentMode.scaleAspectFill}
                imageTT.append(imageTwoThree)
            }
            let imageTTStack = StackLayout(
                axis: .vertical,
                spacing: 2,
                sublayouts: imageTT)
            let imageGlobalStack = StackLayout(
                axis: .horizontal,
                spacing: 2,
                sublayouts: [imageOne, imageTTStack])
            children.append(imageGlobalStack)
        } else if post.imageOfPost.count == 4 {
            let imageOne = SizeLayout<UIImageView>(
                width: ((2 * (W / 3)) - 1),
                height: ((W) - 1)) { imageView in
                    imageView.layer.masksToBounds = true
                    imageView.layer.cornerRadius = 5
                    imageView.yy_setImage(with: URL(string: post.imageOfPost[0]), options: .setImageWithFadeAnimation)
                    imageView.backgroundColor = UIColor.black.withAlphaComponent(0.1)
                    imageView.contentMode = UIViewContentMode.scaleAspectFill}
            let img = post.imageOfPost.dropFirst()
            for item in img {
                let imageTwoThreeFour = SizeLayout<UIImageView>(
                    width: ((W / 3) - 1),
                    height: ((W / 3) - 2)) { imageView in
                        imageView.layer.masksToBounds = true
                        imageView.layer.cornerRadius = 5
                        imageView.yy_setImage(with: URL(string: item), options: .setImageWithFadeAnimation)
                        imageView.backgroundColor = UIColor.black.withAlphaComponent(0.1)
                        imageView.contentMode = UIViewContentMode.scaleAspectFill}
                imageU.append(imageTwoThreeFour)
            }
            let imageStack = StackLayout(
                axis: .vertical,
                spacing: 3,
                sublayouts: imageU)
            let imageGlobalStack = StackLayout(
                axis: .horizontal,
                spacing: 2,
                sublayouts: [imageOne, imageStack])
            children.append(imageGlobalStack)
        } else if post.imageOfPost.count == 5 {
            let imgU = [post.imageOfPost[0], post.imageOfPost[1]]
            let imgD = [post.imageOfPost[2], post.imageOfPost[3], post.imageOfPost[4]]
            for item in imgU {
                let imageOneTwo = SizeLayout<UIImageView>(
                    width: ((W / 2) - 1),
                    height: ((2 * (W / 3)) - 1)) { imageView in
                        imageView.layer.masksToBounds = true
                        imageView.layer.cornerRadius = 5
                        imageView.yy_setImage(with: URL(string: item), options: .setImageWithFadeAnimation)
                        imageView.backgroundColor = UIColor.black.withAlphaComponent(0.1)
                        imageView.contentMode = UIViewContentMode.scaleAspectFill}
                imageU.append(imageOneTwo)
            }
            for item in imgD {
                let imageThreeFourFive = SizeLayout<UIImageView>(
                    width: ((W / 3) - 1),
                    height: ((W / 3) - 1)) { imageView in
                        imageView.layer.masksToBounds = true
                        imageView.layer.cornerRadius = 5
                        imageView.yy_setImage(with: URL(string: item), options: .setImageWithFadeAnimation)
                        imageView.backgroundColor = UIColor.black.withAlphaComponent(0.1)
                        imageView.contentMode = UIViewContentMode.scaleAspectFill}
                imageD.append(imageThreeFourFive)
            }
            let imageUp = StackLayout(
                axis: .horizontal,
                spacing: 2,
                sublayouts: imageU)
            let imageDown = StackLayout(
                axis: .horizontal,
                spacing: 1.5,
                sublayouts: imageD)
            let imageGlobalStack = StackLayout(
                axis: .vertical,
                spacing: 2,
                sublayouts: [imageUp, imageDown])
            children.append(imageGlobalStack)
        } else if post.imageOfPost.count == 6 {
            let imgL = [post.imageOfPost[0], post.imageOfPost[2], post.imageOfPost[4]]
            let imgR = [post.imageOfPost[1], post.imageOfPost[3], post.imageOfPost[5]]
            for item in imgL {
                let imageOneThreeFive = SizeLayout<UIImageView>(
                    width: ((W / 2) - 1),
                    height: ((W / 3) - 1)) { imageView in
                        imageView.layer.masksToBounds = true
                        imageView.layer.cornerRadius = 5
                        imageView.yy_setImage(with: URL(string: item), options: .setImageWithFadeAnimation)
                        imageView.backgroundColor = UIColor.black.withAlphaComponent(0.1)
                        imageView.contentMode = UIViewContentMode.scaleAspectFill}
                imageU.append(imageOneThreeFive)
            }
            for item in imgR {
                let imageTwoFourSix = SizeLayout<UIImageView>(
                    width: ((W / 2) - 1),
                    height: ((W / 3) - 1)) { imageView in
                        imageView.layer.masksToBounds = true
                        imageView.layer.cornerRadius = 5
                        imageView.yy_setImage(with: URL(string: item), options: .setImageWithFadeAnimation)
                        imageView.backgroundColor = UIColor.black.withAlphaComponent(0.1)
                        imageView.contentMode = UIViewContentMode.scaleAspectFill}
                imageD.append(imageTwoFourSix)
            }
            let imageLeft = StackLayout(
                axis: .vertical,
                spacing: 2,
                sublayouts: imageU)
            let imageRight = StackLayout(
                axis: .vertical,
                spacing: 2,
                sublayouts: imageD)
            let imageGlobalStack = StackLayout(
                axis: .horizontal,
                spacing: 2,
                sublayouts: [imageLeft, imageRight])
            children.append(imageGlobalStack)
        } else if post.imageOfPost.count == 7 {
            let imgU = [post.imageOfPost[0], post.imageOfPost[1]]
            let imgM = [post.imageOfPost[2], post.imageOfPost[3], post.imageOfPost[4]]
            let imgD = [post.imageOfPost[5], post.imageOfPost[6]]
            for item in imgU {
                let imageOneTwo = SizeLayout<UIImageView>(
                    width: ((W / 2) - 1),
                    height: ((W / 3) - 1)) { imageView in
                        imageView.layer.masksToBounds = true
                        imageView.layer.cornerRadius = 5
                        imageView.yy_setImage(with: URL(string: item), options: .setImageWithFadeAnimation)
                        imageView.backgroundColor = UIColor.black.withAlphaComponent(0.1)
                        imageView.contentMode = UIViewContentMode.scaleAspectFill}
                imageU.append(imageOneTwo)
            }
            for item in imgM {
                let imageThreeFourFive = SizeLayout<UIImageView>(
                    width: ((W / 3) - 1),
                    height: ((W / 3) - 1)) { imageView in
                        imageView.layer.masksToBounds = true
                        imageView.layer.cornerRadius = 5
                        imageView.yy_setImage(with: URL(string: item), options: .setImageWithFadeAnimation)
                        imageView.backgroundColor = UIColor.black.withAlphaComponent(0.1)
                        imageView.contentMode = UIViewContentMode.scaleAspectFill}
                imageM.append(imageThreeFourFive)
            }
            for item in imgD {
                let imageSixSeven = SizeLayout<UIImageView>(
                    width: ((W / 2) - 1),
                    height: ((W / 3) - 1)) { imageView in
                        imageView.layer.masksToBounds = true
                        imageView.layer.cornerRadius = 5
                        imageView.yy_setImage(with: URL(string: item), options: .setImageWithFadeAnimation)
                        imageView.backgroundColor = UIColor.black.withAlphaComponent(0.1)
                        imageView.contentMode = UIViewContentMode.scaleAspectFill}
                imageD.append(imageSixSeven)
            }
            let imageUp = StackLayout(
                axis: .horizontal,
                spacing: 2,
                sublayouts: imageU)
            let imageMiddle = StackLayout(
                axis: .horizontal,
                spacing: 1.5,
                sublayouts: imageM)
            let imageDown = StackLayout(
                axis: .horizontal,
                spacing: 2,
                sublayouts: imageD)
            let imageGlobalStack = StackLayout(
                axis: .vertical,
                spacing: 1.5,
                sublayouts: [imageUp, imageMiddle, imageDown])
            children.append(imageGlobalStack)
        } else if post.imageOfPost.count == 8 {
            let imgU = [post.imageOfPost[0], post.imageOfPost[1], post.imageOfPost[2]]
            let imgM = [post.imageOfPost[3], post.imageOfPost[4]]
            let imgD = [post.imageOfPost[5], post.imageOfPost[6], post.imageOfPost[7]]
            for item in imgU {
                let imageOneTwoThree = SizeLayout<UIImageView>(
                    width: ((W / 3) - 1),
                    height: ((W / 3) - 1)) { imageView in
                        imageView.layer.masksToBounds = true
                        imageView.layer.cornerRadius = 5
                        imageView.yy_setImage(with: URL(string: item), options: .setImageWithFadeAnimation)
                        imageView.backgroundColor = UIColor.black.withAlphaComponent(0.1)
                        imageView.contentMode = UIViewContentMode.scaleAspectFill}
                imageU.append(imageOneTwoThree)
            }
            for item in imgM {
                let imageFourFive = SizeLayout<UIImageView>(
                    width: ((W / 2) - 1),
                    height: ((W / 3) - 1)) { imageView in
                        imageView.layer.masksToBounds = true
                        imageView.layer.cornerRadius = 5
                        imageView.yy_setImage(with: URL(string: item), options: .setImageWithFadeAnimation)
                        imageView.backgroundColor = UIColor.black.withAlphaComponent(0.1)
                        imageView.contentMode = UIViewContentMode.scaleAspectFill}
                imageM.append(imageFourFive)
            }
            for item in imgD {
                let imageSixSevenEight = SizeLayout<UIImageView>(
                    width: ((W / 3) - 1),
                    height: ((W / 3) - 1)) { imageView in
                        imageView.layer.masksToBounds = true
                        imageView.layer.cornerRadius = 5
                        imageView.yy_setImage(with: URL(string: item), options: .setImageWithFadeAnimation)
                        imageView.backgroundColor = UIColor.black.withAlphaComponent(0.1)
                        imageView.contentMode = UIViewContentMode.scaleAspectFill}
                imageD.append(imageSixSevenEight)
            }
            let imageUp = StackLayout(
                axis: .horizontal,
                spacing: 1.5,
                sublayouts: imageU)
            let imageMiddle = StackLayout(
                axis: .horizontal,
                spacing: 2,
                sublayouts: imageM)
            let imageDown = StackLayout(
                axis: .horizontal,
                spacing: 1.5,
                sublayouts: imageD)
            let imageGlobalStack = StackLayout(
                axis: .vertical,
                spacing: 1.5,
                sublayouts: [imageUp, imageMiddle, imageDown])
            children.append(imageGlobalStack)
        } else if post.imageOfPost.count == 9 {
            let imgU = [post.imageOfPost[0], post.imageOfPost[1], post.imageOfPost[2]]
            let imgM = [post.imageOfPost[3], post.imageOfPost[4], post.imageOfPost[5]]
            let imgD = [post.imageOfPost[6], post.imageOfPost[7], post.imageOfPost[8]]
            for item in imgU {
                let imageOneTwoThree = SizeLayout<UIImageView>(
                    width: ((W / 3) - 1),
                    height: ((W / 3) - 1)) { imageView in
                        imageView.layer.masksToBounds = true
                        imageView.layer.cornerRadius = 5
                        imageView.yy_setImage(with: URL(string: item), options: .setImageWithFadeAnimation)
                        imageView.backgroundColor = UIColor.black.withAlphaComponent(0.1)
                        imageView.contentMode = UIViewContentMode.scaleAspectFill}
                imageU.append(imageOneTwoThree)
            }
            for item in imgM {
                let imageFourFiveSix = SizeLayout<UIImageView>(
                    width: ((W / 3) - 1),
                    height: ((W / 3) - 1)) { imageView in
                        imageView.layer.masksToBounds = true
                        imageView.layer.cornerRadius = 5
                        imageView.yy_setImage(with: URL(string: item), options: .setImageWithFadeAnimation)
                        imageView.backgroundColor = UIColor.black.withAlphaComponent(0.1)
                        imageView.contentMode = UIViewContentMode.scaleAspectFill}
                imageM.append(imageFourFiveSix)
            }
            for item in imgD {
                let imageSevenEightNine = SizeLayout<UIImageView>(
                    width: ((W / 3) - 1),
                    height: ((W / 3) - 1)) { imageView in
                        imageView.layer.masksToBounds = true
                        imageView.layer.cornerRadius = 5
                        imageView.yy_setImage(with: URL(string: item), options: .setImageWithFadeAnimation)
                        imageView.backgroundColor = UIColor.black.withAlphaComponent(0.1)
                        imageView.contentMode = UIViewContentMode.scaleAspectFill}
                imageD.append(imageSevenEightNine)
            }
            let imageUp = StackLayout(
                axis: .horizontal,
                spacing: 1.5,
                sublayouts: imageU)
            let imageMiddle = StackLayout(
                axis: .horizontal,
                spacing: 1.5,
                sublayouts: imageM)
            let imageDown = StackLayout(
                axis: .horizontal,
                spacing: 1.5,
                sublayouts: imageD)
            let imageGlobalStack = StackLayout(
                axis: .vertical,
                spacing: 1.5,
                sublayouts: [imageUp, imageMiddle, imageDown])
            children.append(imageGlobalStack)
        } else if post.imageOfPost.count == 10 {
            let imgU = [post.imageOfPost[0], post.imageOfPost[1], post.imageOfPost[2]]
            let imgM = [post.imageOfPost[3], post.imageOfPost[4], post.imageOfPost[5], post.imageOfPost[6]]
            let imgD = [post.imageOfPost[7], post.imageOfPost[8], post.imageOfPost[9]]
            for item in imgU {
                let imageOneTwoThree = SizeLayout<UIImageView>(
                    width: ((W / 3) - 1),
                    height: ((W / 3) - 1)) { imageView in
                        imageView.layer.masksToBounds = true
                        imageView.layer.cornerRadius = 5
                        imageView.yy_setImage(with: URL(string: item), options: .setImageWithFadeAnimation)
                        imageView.backgroundColor = UIColor.black.withAlphaComponent(0.1)
                        imageView.contentMode = UIViewContentMode.scaleAspectFill}
                imageU.append(imageOneTwoThree)
            }
            for item in imgM {
                let imageFourFiveSixSeven = SizeLayout<UIImageView>(
                    width: (W / 4),
                    height: ((W / 3) - 1)) { imageView in
                        imageView.layer.masksToBounds = true
                        imageView.layer.cornerRadius = 5
                        imageView.yy_setImage(with: URL(string: item), options: .setImageWithFadeAnimation)
                        imageView.backgroundColor = UIColor.black.withAlphaComponent(0.1)
                        imageView.contentMode = UIViewContentMode.scaleAspectFill}
                imageM.append(imageFourFiveSixSeven)
            }
            for item in imgD {
                let imageEightNineTen = SizeLayout<UIImageView>(
                    width: ((W / 3) - 1),
                    height: ((W / 3) - 1)) { imageView in
                        imageView.layer.masksToBounds = true
                        imageView.layer.cornerRadius = 5
                        imageView.yy_setImage(with: URL(string: item), options: .setImageWithFadeAnimation)
                        imageView.backgroundColor = UIColor.black.withAlphaComponent(0.1)
                        imageView.contentMode = UIViewContentMode.scaleAspectFill}
                imageD.append(imageEightNineTen)
            }
            let imageUp = StackLayout(
                axis: .horizontal,
                spacing: 1.5,
                sublayouts: imageU)
            let imageMiddle = StackLayout(
                axis: .horizontal,
                spacing: 0,
                sublayouts: imageM)
            let imageDown = StackLayout(
                axis: .horizontal,
                spacing: 1.5,
                sublayouts: imageD)
            let imageGlobalStack = StackLayout(
                axis: .vertical,
                spacing: 1.5,
                sublayouts: [imageUp, imageMiddle, imageDown])
            children.append(imageGlobalStack)
        }
        // MARK: - VIDEO OF POST
        if post.videoID.count >= 1 {
            let videoID = post.videoID[0]
            let ownerVideoID = post.ownerVideoID[videoID]
            let imageOfVideo = post.imageOfVideo[videoID]
            let nameOfVideo = post.nameOfVideo[videoID]
            //let videoPlayer = post.videoPlayer[videoID]
            let videoKey = post.videoKey[videoID]
            let imageOfVideoLayout = SizeLayout<UIImageView>(
                width: UIScreen.main.bounds.width,
                height: UIScreen.main.bounds.width,
                viewReuseId: "post_imageOfVideo") { imageView in
                    imageView.layer.masksToBounds = true
                    imageView.layer.cornerRadius = 5
                    imageView.yy_setImage(with: URL(string: imageOfVideo!), options: .setImageWithFadeAnimation)
                    imageView.backgroundColor = UIColor.black.withAlphaComponent(0.1)
                    imageView.contentMode = UIViewContentMode.scaleAspectFit
            }
            let buttonOfVideoLayout = ButtonLayout<MyButton>(
                type: .custom,
                title: "▶️ \(nameOfVideo!)",
                font: UIFont.systemFont(ofSize: 18),
                viewReuseId: "post_buttonOfVideo") { (buttonOfVideoLayout) in
                    buttonOfVideoLayout.setTitleColor(UIColor.black.withAlphaComponent(0.9), for: .normal)
                    //                buttonOfVideoLayout.backgroundColor = UIColor.black.withAlphaComponent(0.2)
                    buttonOfVideoLayout.tap = {
                        let n = Notification(name: Notification.Name("video"), object: nil, userInfo: [
                            "videoKey": videoKey!,
                            "videoID": videoID,
                            "ownerVideoID": ownerVideoID!
                            ])
                        NotificationCenter.default.post(n)
                    }
            }
            
            let videoStack = StackLayout(
                axis: .vertical,
                spacing: 8,
                sublayouts: [imageOfVideoLayout, buttonOfVideoLayout])
                children.append(videoStack)
        }
        // MARK: - AUDIO OF POST
//        let playAudioImage = SizeLayout<UIImageView>(
//            width: 20,
//            height: 20,
//            viewReuseId: "post_playAudioImage") { imageView in
//                imageView.layer.masksToBounds = true
//                imageView.layer.cornerRadius = 5
//                imageView.image = UIImage(named: "play audio")
//                imageView.backgroundColor = UIColor.white
//        }
        let buttonOfSongLayout = ButtonLayout<MyButton>(
            type: .custom,
            title: "▶️ \(post.artistOfSong) - \(post.nameOfSong)",
            font: UIFont.systemFont(ofSize: 20),
            viewReuseId: "post_buttonOfSong") { (buttonOfSongLayout) in
                buttonOfSongLayout.setTitleColor(UIColor.black.withAlphaComponent(0.9), for: UIControlState.normal)
                buttonOfSongLayout.backgroundColor = UIColor.white
                buttonOfSongLayout.tap = {
                    let n = Notification(name: Notification.Name("audio"), object: nil, userInfo: [
                        "audioURL": post.audioURL
                        ])
                    NotificationCenter.default.post(n)
                }
        }
//        let audioStack = StackLayout(
//            axis: .horizontal,
//            spacing: 5,
//            viewReuseId: "post_audioStack",
//            sublayouts: [playAudioImage, buttonOfSongLayout])
        if post.audioURL != "" {
            children.append(buttonOfSongLayout)
        }
        // MARK: - LINK OF POST
        if post.nameOfLink.count >= 1 {
            let linkTitle = post.nameOfLink[0]
            let linkURL = post.linkURL[linkTitle]
//            let goToLinkImage = SizeLayout<UIImageView>(
//                width: 20,
//                height: 20,
//                viewReuseId: "post_goToLink") { imageView in
//                    imageView.layer.masksToBounds = true
//                    imageView.layer.cornerRadius = 5
//                    imageView.image = UIImage(named: "go to link")
//                    imageView.backgroundColor = UIColor.white
//            }
            let buttonOfLinkLayout = ButtonLayout<MyButton>(
                type: .custom,
                title: "↗️ \(linkTitle)",
                font: UIFont.systemFont(ofSize: 18),
                viewReuseId: "post_buttonOfLink") { (buttonOfLinkLayout) in
                    buttonOfLinkLayout.setTitleColor(UIColor.black.withAlphaComponent(0.9), for: UIControlState.normal)
                    buttonOfLinkLayout.backgroundColor = UIColor.white
                    buttonOfLinkLayout.tap = {
                        let n = Notification(name: Notification.Name("link"), object: nil, userInfo: [
                            "link": linkURL!
                            ])
                        NotificationCenter.default.post(n)
                    }
            }
//            let linkStack = StackLayout(
//                axis: .horizontal,
//                spacing: 5,
//                viewReuseId: "post_linkStack",
//                sublayouts: [goToLinkImage, buttonOfLinkLayout ])
                children.append(buttonOfLinkLayout)
        }
        // MARK: - GEO OF POST
        let geoImage = SizeLayout<UIImageView>(
            width: 34,
            height: 34,
            viewReuseId: "post_geo") { imageView in
                imageView.layer.masksToBounds = true
                imageView.image = UIImage(named: "addGeoPinON")
        }
        let titleOfGeo = LabelLayout(
            text: post.geoTitle,
            font: UIFont.systemFont(ofSize: 18),
            viewReuseId: "post_titleOfGeo") { label in
                label.textColor = UIColor.black.withAlphaComponent(0.9)
                label.backgroundColor = UIColor.white}
        
        let coordOfGeo = LabelLayout(
            text: post.geoCoord,
            font: UIFont.systemFont(ofSize: 14),
            viewReuseId: "post_coordOfGeo") { label in
                label.textColor = UIColor.black.withAlphaComponent(0.3)
                label.backgroundColor = UIColor.white}
        let geoTitleStack = StackLayout(
            axis: .vertical,
            spacing: 3,
            sublayouts: [titleOfGeo, coordOfGeo])
        let geoStack = StackLayout(
            axis: .horizontal,
            spacing: 2,
            sublayouts: [geoImage, geoTitleStack])
        if post.geoTitle != "" {
            children.append(geoStack)
        }
        // MARK: - BOTTOM OF POST: LIKES, COMMENTS, REPOSTS, WATCHS
        let likesOfPostLayout = LabelLayout(
            text: "🖤: \(post.likesOfPost)",
            font: UIFont.systemFont(ofSize: 14),
            viewReuseId: "post_likesOfPost") { label in
                label.textColor = UIColor.black.withAlphaComponent(0.8)
                label.backgroundColor = UIColor.white
        }
        let commentsOfPostLayout = LabelLayout(
            text: "✉️: \(post.commentsOfPost)",
            font: UIFont.systemFont(ofSize: 14),
            viewReuseId: "post_commentsOfPost") { label in
                label.textColor = UIColor.black.withAlphaComponent(0.8)
                label.backgroundColor = UIColor.white
        }
        let repostsOfPostLayout = LabelLayout(
            text: "📣: \(post.repostsOfPost)",
            font: UIFont.systemFont(ofSize: 14),
            viewReuseId: "post_repostsOfPost") { label in
                label.textColor = UIColor.black.withAlphaComponent(0.8)
                label.backgroundColor = UIColor.white
        }
        let watchsOfPostLayout = LabelLayout(
            text: "👀: \(post.watchsOfPost)",
            font: UIFont.systemFont(ofSize: 14),
            viewReuseId: "post_watchsOfPost") { label in
                label.textColor = UIColor.black.withAlphaComponent(0.8)
                label.backgroundColor = UIColor.white
        }
        let lcrwBottomStack = StackLayout(
            axis: .horizontal,
            spacing: 8,
            distribution: .fillEqualSpacing,
            sublayouts: [likesOfPostLayout, commentsOfPostLayout, repostsOfPostLayout, watchsOfPostLayout])
        children.append(lcrwBottomStack)
        // MARK: - GLOBAL STACK
        let globalStack = StackLayout(
            axis: .vertical,
            spacing: 8,
            sublayouts: children)
        
        super.init(insets: UIEdgeInsetsMake(8.0, 8.0, 16.0, 8.0),
            viewReuseId: "post_view",
        sublayout: globalStack) { view in
            view.backgroundColor = UIColor.white
        }
        
    }
}
final class PostLayoutViewModel: GenericLayoutViewModel<Post> { 
    override func makeLayout() -> Layout {
        return PostLayout(post: model)
    }
}

