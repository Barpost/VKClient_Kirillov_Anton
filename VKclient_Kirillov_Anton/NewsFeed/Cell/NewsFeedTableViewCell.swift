//
//  NewsFeedTableViewCell.swift
//  VKclient_Kirillov_Anton
//
//  Created by Антон Кириллов on 17.10.2017.
//  Copyright © 2017 Barpost. All rights reserved.
//

import UIKit
import YYWebImage

// убрать все констрейнты у контента внутри, выставить только размеры стаков и имаги и текста наверху и все
// посчитай и все и подели

class NewsFeedTableViewCell: UITableViewCell {
    //MARK: - постоянники поста
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var nameOfAvatar: UILabel!
    @IBOutlet weak var dateOfPost: UILabel!
    @IBOutlet weak var likesOfPost: UILabel!
    @IBOutlet weak var commentsOfPost: UILabel!
    @IBOutlet weak var repostsOfPost: UILabel!
    @IBOutlet weak var watchsOfPost: UILabel!
    //MARK: - текст поста
    @IBOutlet weak var textOfPost: UILabel!  //придумать "more..."
    @IBOutlet weak var heihgtTextOfPostConstraint: NSLayoutConstraint!
    //MARK: - репост
    @IBOutlet weak var textOfRepost: UILabel! 
    @IBOutlet weak var fromWhoRepostStackView: UIStackView!
    @IBOutlet weak var fromWhoRepostImage: UIImageView!
    @IBOutlet weak var fromWhoRepostName: UILabel!
    @IBOutlet weak var fromWhoRepostDate: UILabel!
    //MARK: - фотка поста
    @IBOutlet weak var imageOfPost: UIImageView!
    //MARK: - видео поста
    @IBOutlet weak var imageOfVideo: UIImageView!
    @IBOutlet weak var heightOfVideoImage: NSLayoutConstraint!
    @IBOutlet weak var nameOfVideo: UILabel!
    @IBOutlet weak var heightNameOfVideo: NSLayoutConstraint!
    @IBOutlet weak var videoStack: UIStackView!
    @IBOutlet weak var heightVideoStackConstraint: NSLayoutConstraint!
    @IBOutlet weak var buttonOfVideo: UIButton!
    @IBOutlet weak var heightOfButtonVideo: NSLayoutConstraint!
    //MARK: - аудио поста
    @IBOutlet weak var nameOfSong: UILabel!
    @IBOutlet weak var heightOfNameAudio: NSLayoutConstraint!
    @IBOutlet weak var audioStack: UIStackView!
    @IBOutlet weak var buttonOfAudio: UIButton!
    @IBOutlet weak var heightOfButtonAudio: NSLayoutConstraint!
    @IBOutlet weak var heightAudioStackConstraint: NSLayoutConstraint!
    //MARK: - линк поста
    @IBOutlet weak var nameOfLink: UILabel!
    @IBOutlet weak var heightOfNameLink: NSLayoutConstraint!
    @IBOutlet weak var linkStack: UIStackView!
    @IBOutlet weak var heightLinkStackConstraint: NSLayoutConstraint!
    @IBOutlet weak var buttonOfLink: UIButton!
    @IBOutlet weak var heightOfButtonLink: NSLayoutConstraint!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        avatarImage.yy_cancelCurrentImageRequest()
        avatarImage.image = nil
        imageOfPost.yy_cancelCurrentImageRequest()
        imageOfPost.image = nil
        imageOfVideo.yy_cancelCurrentImageRequest()
        imageOfVideo.image = nil
        fromWhoRepostImage.yy_cancelCurrentImageRequest()
        fromWhoRepostImage.image = nil
        
        textOfPost.isHidden = true
        imageOfPost.isHidden = true
        
        textOfRepost.isHidden = true
        fromWhoRepostStackView.isHidden = true
        
        videoStack.isHidden = true
        buttonOfVideo.isHidden = true
        
        audioStack.isHidden = true
        buttonOfAudio.isHidden = true
        
        linkStack.isHidden = true
        buttonOfLink.isHidden = true
    }
    
    func configure(withNewsFeed newsFeed: NewsFeed) {
        
        nameOfAvatar.text = newsFeed.nameWhosePost
        dateOfPost.text = newsFeed.date
        avatarImage?.layer.cornerRadius = 25
        avatarImage.yy_setImage(with: URL(string: newsFeed.photoWhosePost), options: .setImageWithFadeAnimation)
        likesOfPost.text = " \(newsFeed.likesPost)"
        commentsOfPost.text = " \(newsFeed.commentsPost)"
        repostsOfPost.text = " \(newsFeed.repostsPost)"
        watchsOfPost.text = " \(newsFeed.watchsPost)"
        
        if newsFeed.textOfPost != "" {
            textOfPost.isHidden = false
            textOfPost.text = newsFeed.textOfPost
        }
        if newsFeed.photoPhoto != "" {
            imageOfPost.isHidden = false
            imageOfPost?.layer.cornerRadius = 5.0
            imageOfPost.yy_setImage(with: URL(string: newsFeed.photoPhoto), options: .setImageWithFadeAnimation)
        }
        
        if newsFeed.textOfRepost != "" {
            textOfRepost.isHidden = false
            textOfRepost.text = newsFeed.textOfRepost
        }
        
        if newsFeed.whoseRepostName != "" {
            fromWhoRepostStackView.isHidden = false
            fromWhoRepostImage?.layer.cornerRadius = 16
            fromWhoRepostImage.yy_setImage(with: URL(string: newsFeed.whoseRepostPhoto), options: .setImageWithFadeAnimation)
            fromWhoRepostName.text = "Re: \(newsFeed.whoseRepostName)"
            fromWhoRepostDate.text = newsFeed.dateOfRepost
        }

        if newsFeed.videoID != 0 {
            videoStack.isHidden = false
            buttonOfVideo.isHidden = false
            nameOfVideo.text = newsFeed.videoTitle
            imageOfVideo?.layer.cornerRadius = 5.0
            imageOfVideo.yy_setImage(with: URL(string: newsFeed.videoPhoto), options: .setImageWithFadeAnimation)
        }
        if newsFeed.audioID != 0 {
            audioStack.isHidden = false
            buttonOfAudio.isHidden = false
            nameOfSong.text = "\(newsFeed.audioArtist) - \(newsFeed.audioTitle)"
        }
        if newsFeed.linkURL != "" {
            linkStack.isHidden = false
            buttonOfLink.isHidden = false
            nameOfLink.text = newsFeed.linkTitle
        }
    }
}

