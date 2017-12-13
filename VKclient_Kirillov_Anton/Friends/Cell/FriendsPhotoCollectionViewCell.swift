//
//  FriendsPhotoCollectionViewCell.swift
//  VKclient_Kirillov_Anton
//
//  Created by Антон Кириллов on 27.09.17.
//  Copyright © 2017 Barpost. All rights reserved.
//

import UIKit
import YYWebImage

class FriendsPhotoCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var images: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()

        images.yy_cancelCurrentImageRequest()
        images.image = nil
    }

    func configure(withFriendImage friendImage: FriendImage) {
        var count = 0
        if friendImage.friendPhoto == "" {
            repeat {
                images.yy_setImage(with: URL(string: friendImage.friendPhoto), options: .setImageWithFadeAnimation)
                count = count + 1
            } while  ((count < 3) || (friendImage.friendPhoto != ""))
            print("сколько он пытался - \(count)")
        } else {
            images.yy_setImage(with: URL(string: friendImage.friendPhoto), options: .setImageWithFadeAnimation)
        }
    }
}
