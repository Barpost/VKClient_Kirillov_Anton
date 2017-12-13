//
//  Player.swift
//  VKclient_Kirillov_Anton
//
//  Created by Антон Кириллов on 26.10.2017.
//  Copyright © 2017 Barpost. All rights reserved.
//

import UIKit
import WebKit

class PlayerViewController: UIViewController {
    
    @IBOutlet weak var webView: UIWebView!

    var items = [Video]()
    let ownerID = userDefaults.string(forKey: "ownerVideoID")
    let videoID = userDefaults.string(forKey: "videoID")
    let accessKey = userDefaults.string(forKey: "videoKey")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        APIService.shared.getVideo(ownerID: ownerID!, videoID: videoID!, accessKey: accessKey!) { [weak self] items in
            guard let strongSelf = self else { return }
            strongSelf.items = items
            let url = URL(string: items[0].videoPlayer)
            let request = URLRequest(url: url!)
            self?.webView.loadRequest(request)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override var prefersStatusBarHidden: Bool{
        return true
    }
}

struct Video {
    var videoPlayer: String
    var videoID: String
    var ownerID: String
}
