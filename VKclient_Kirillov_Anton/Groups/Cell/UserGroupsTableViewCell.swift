//
//  UserGroupsTableViewCell.swift
//  VKclient_Kirillov_Anton
//
//  Created by Антон Кириллов on 27.09.17.
//  Copyright © 2017 Barpost. All rights reserved.
//

import UIKit
import YYWebImage

class UserGroupsCell: UITableViewCell {
    @IBOutlet weak var groupImage: UIImageView!
    @IBOutlet weak var groupName: UILabel!

    override func prepareForReuse() {
        super.prepareForReuse()
        
        groupImage.yy_cancelCurrentImageRequest() 
        groupImage.image = nil
    }
    
    func configure(withUserGroupInfo userGroupInfo: UserGroupInfo) {
        groupName.text = userGroupInfo.name
        groupImage.layer.masksToBounds = true
        groupImage.layer.cornerRadius = 30
        groupImage.yy_setImage(with: URL(string: userGroupInfo.image), options: .setImageWithFadeAnimation)
    }
}
