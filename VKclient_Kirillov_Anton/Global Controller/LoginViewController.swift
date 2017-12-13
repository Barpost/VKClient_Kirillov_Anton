//
//  LoginViewController.swift
//  VKclient_Kirillov_Anton
//
//  Created by Антон Кириллов on 27.09.17.
//  Copyright © 2017 Barpost. All rights reserved.
//

import UIKit
import WebKit 
import Alamofire
import RealmSwift

class LoginViewController: UIViewController {
    
    @IBOutlet weak var webview: WKWebView!{
        didSet {
            webview.navigationDelegate = self
        }
    }
    
    let service = APIService.shared
    
    var token = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        webview.load(service.getrequest())
    }
}

extension LoginViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationResponse: WKNavigationResponse,
                 decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        
        guard let url = navigationResponse.response.url,
            url.path == "/blank.html",
            let fragment = url.fragment  else {
                decisionHandler(.allow)
                return
        }
        let params = fragment
            .components(separatedBy: "&")
            .map { $0.components(separatedBy: "=") }
            .reduce([String: String]()) { result, param in
                var dict = result
                let key = param[0]
                let value = param[1]
                dict[key] = value
                return dict
        }
        let userID = params["user_id"]
        userDefaults.set(userID!, forKey: "userID")
        defaults?.set(userID!, forKey: "userID")
        print("вот айди того кто зарегался - \(userID!)")
        self.token = params["access_token"]!
        print("вот твой акссес токен - \(token)")
        service.accessToken = token
        defaults?.set(token, forKey: "accessToken")
        decisionHandler(.cancel)
        performSegue(withIdentifier: "homeSegue", sender: token)
    }
}

