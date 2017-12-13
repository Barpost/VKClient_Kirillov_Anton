//
//  LayoutListViewController.swift
//  VKclient_Kirillov_Anton
//
//  Created by Антон Кириллов on 22.10.2017.
//  Copyright © 2017 Barpost. All rights reserved.
//

import Foundation
import UIKit
import IGListKit

open class LayoutListViewController: UIViewController {
    
    private weak var collectionView: UICollectionView?
    private var dataSource: LayoutListDataSource?
    private var refresher: UIRefreshControl!
    
    override open func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        let collectionView = UICollectionView(
            frame: CGRect(origin: .zero,
                          size: CGSize(width: UIScreen.main.bounds.width,
                                       height: view.bounds.height)),
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        
        refresher = UIRefreshControl()
        refresher.tintColor = UIColor.darkGray
        refresher.attributedTitle = NSAttributedString(string: "update this shit")
        refresher.addTarget(self, action: #selector(ViewController.viewDidLoad), for: UIControlEvents.valueChanged)
        collectionView.addSubview(refresher)
        
        collectionView.backgroundColor = UIColor.white
        
        collectionView.autoresizingMask = [.flexibleHeight]
        
        view.addSubview(collectionView)
        
        self.collectionView = collectionView
        
        dataSource = LayoutListDataSource(
            viewController: self,
            collectionView: collectionView,
            workingRangeSize: 0
        )
    }

    public func set(viewModels: [LayoutViewModel]) {
        dataSource?.set(viewModels: viewModels, animated: true)
    }
}
