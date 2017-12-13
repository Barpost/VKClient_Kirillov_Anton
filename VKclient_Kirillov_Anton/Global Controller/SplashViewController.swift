//
//  SplashViewController.swift
//  VKclient_Kirillov_Anton
//
//  Created by Антон Кириллов on 27.09.17.
//  Copyright © 2017 Barpost. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {
    
    @IBOutlet weak var gradientView: UIImageView!
    @IBOutlet weak var logoImage: UIImageView!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
        animateBackgroundColor()
    }
    
    func animateBackgroundColor() {
        UIView.animate(withDuration: 25, delay: 0, options: [.autoreverse, .curveLinear, .repeat], animations: {
            let x = -(self.gradientView.frame.width - self.view.frame.width)
            let y = -(self.gradientView.frame.height - self.view.frame.height)
            self.gradientView.transform = CGAffineTransform.init(translationX: x, y: y)
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if(!appDelegate.splashDelay) {
            delay(0.5, closure: {
                DispatchQueue.main.async {
                    if APIService.shared.accessToken.isEmpty {
                        self.performSegue(withIdentifier: "loginSegue", sender: self)
                    } else {
                        self.performSegue(withIdentifier: "homeSegue", sender: self)
                    }
                }
            })
        }
    }

    
}
