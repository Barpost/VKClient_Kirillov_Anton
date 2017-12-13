//
//  DetailViewController.swift
//  VKclient_Kirillov_Anton
//
//  Created by Антон Кириллов on 03.10.17.
//  Copyright © 2017 Barpost. All rights reserved.
//

import UIKit
import YYWebImage

class DetailViewController: UIViewController {
    
    @IBOutlet weak var PhotoView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Photo"
        PhotoView.yy_cancelCurrentImageRequest()
        PhotoView.image = nil
        PhotoView.yy_setImage(with: URL(string: userDefaults.string(forKey: "bigPhoto")!), options: .setImageWithFadeAnimation)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension DetailViewController: ZoomingViewController {
    
    func zoomingBackgroundView(for transition: ZoomTransitioningDelegate) -> UIView? {
        return nil
    }
    
    func zoomingImageView(for transition: ZoomTransitioningDelegate) -> UIImageView? {
        return PhotoView
    }
}
