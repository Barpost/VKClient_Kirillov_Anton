//
//  AllGroupsTableViewCell.swift
//  VKclient_Kirillov_Anton
//
//  Created by Антон Кириллов on 27.09.17.
//  Copyright © 2017 Barpost. All rights reserved.
//

import UIKit

class AllGroupsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var cellMembers: UILabel!
    @IBOutlet weak var cellLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        cellImage.yy_cancelCurrentImageRequest()
        cellImage.image = nil
    }
    
    func configure(withAllGroupInfo groupInfo: GroupInfo) {
        cellLabel.text = groupInfo.name
        cellMembers.text = groupInfo.memberCount
        cellImage.layer.masksToBounds = true
        cellImage.layer.cornerRadius = 30
        cellImage.yy_setImage(with: URL(string: groupInfo.image), options: .setImageWithFadeAnimation)
    }
}
