//
//  ViewController.swift
//  VKclient_Kirillov_Anton
//
//  Created by Антон Кириллов on 22.10.2017.
//  Copyright © 2017 Barpost. All rights reserved.
//

import UIKit
import RealmSwift
import SwiftyJSON
import SafariServices

class ViewController: LayoutListViewController {
    
    private var hasSubscription: Bool = false
    
    var items = [Post]()
    
    @IBAction func unwindFromAddNewPostToNewsFeed(unwindSegue:UIStoryboardSegue) { }
    @IBAction func unwindFromPlayerToNewsFeed(unwindSegue:UIStoryboardSegue) { }
    @IBAction func unwindFromWebViewToNewsFeed(unwindSegue:UIStoryboardSegue) { }
    @IBAction func unwindFromAudioPlayerToNewsFeed(unwindSegue:UIStoryboardSegue) { }


    
    override func viewDidLoad() {
        super.viewDidLoad()
        APIService.shared.getPosts(user: userDefaults.string(forKey: "userID")!) { [weak self] items in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async{
                let vms = items.map { post -> PostLayoutViewModel in
                    PostLayoutViewModel(id: post.postID, model: post)
                }
                strongSelf.set(viewModels: vms)
            }
        }
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(goToVideoPlayer),
                                               name: NSNotification.Name(rawValue: "video"),
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(goToAudioPlayer),
                                               name: NSNotification.Name(rawValue: "audio"),
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(goToWebView),
                                               name: NSNotification.Name(rawValue: "link"),
                                               object: nil)
        hasSubscription = true
    }
    deinit {
        if hasSubscription {
            NotificationCenter.default.removeObserver(self)
        }
    }
    @objc func goToVideoPlayer(notification: NSNotification) {
        let userInfo = notification.userInfo
        userDefaults.set(userInfo!["videoKey"], forKey: "videoKey")
        userDefaults.set(userInfo!["videoID"], forKey: "videoID")
        userDefaults.set(userInfo!["ownerVideoID"], forKey: "ownerVideoID")
        print("video button tapped")
        self.performSegue(withIdentifier: "showVideoContentSegue", sender: self)
    }
    @objc func goToAudioPlayer(notification: NSNotification) {
        let userInfo = notification.userInfo
        userDefaults.set(userInfo!["audioURL"], forKey: "audioURL")
        print("audio button tapped")
        self.performSegue(withIdentifier: "showAudioContentSegue", sender: self)
    }
    @objc func goToWebView(notification: NSNotification) {
        let userInfo = notification.userInfo
        userDefaults.set(userInfo!["link"], forKey: "linkURL")
        print("web button tapped")
        self.performSegue(withIdentifier: "showWebContentSegue", sender: self)
    }
}

final class MyButton: UIButton {
    public var tap: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addTarget(self, action: #selector(onTap), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    @objc func onTap() {
        tap?()
    }
}
