//
//  UserFriendsTableViewCell.swift
//  VKclient_Kirillov_Anton
//
//  Created by Антон Кириллов on 27.09.17.
//  Copyright © 2017 Barpost. All rights reserved.
//

import UIKit
import YYWebImage

class UserFriendsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var friendsName: UILabel!
    @IBOutlet weak var friendImage: UIImageView!

    override func prepareForReuse() {
        super.prepareForReuse()
    
        friendImage.yy_cancelCurrentImageRequest()
        friendImage.image = nil
    }
    
    func configure(withFriendInfo friendInfo: FriendInfo) {
        friendsName.text = "\(friendInfo.firstname) \(friendInfo.lastname)"
        friendImage.layer.masksToBounds = true
        friendImage.layer.cornerRadius = 40
        friendImage.yy_setImage(with: URL(string: friendInfo.image), options: .setImageWithFadeAnimation)
    }
}
