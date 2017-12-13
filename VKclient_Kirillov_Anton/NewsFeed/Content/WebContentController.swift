//
//  WebContentController.swift
//  VKclient_Kirillov_Anton
//
//  Created by Антон Кириллов on 12.12.2017.
//  Copyright © 2017 Barpost. All rights reserved.
//

import UIKit
import WebKit

class WebContentController: UIViewController {
    
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: userDefaults.string(forKey: "linkURL")!)
        let request = URLRequest(url: url!)
        webView.loadRequest(request)
    }
    
    override var prefersStatusBarHidden: Bool{
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}


