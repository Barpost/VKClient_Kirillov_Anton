//
//  FriendsPhotoCollectionViewController.swift
//  VKclient_Kirillov_Anton
//
//  Created by Антон Кириллов on 27.09.17.
//  Copyright © 2017 Barpost. All rights reserved.
//

import UIKit
import RealmSwift


class FriendsPhotoCollectionViewController: UICollectionViewController {
    
    var friendID = ""
    var friendPhoto = [FriendImage]()
    var selectedIndexPath: IndexPath!
    var userDefaults = UserDefaults.standard
    
    private let leftAndRightPaddings: CGFloat = 2.0
    private let numberOfItemsPerRow: CGFloat = 3.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView?.backgroundColor = UIColor.white
        let collectionViewWidth = collectionView?.frame.width
        let itemWidth = (collectionViewWidth! - leftAndRightPaddings) / numberOfItemsPerRow
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        APIService.shared.getPhotos(whosePhoto: friendID) { [weak self] friendPhoto in
            guard let strongSelf = self else { return }
            strongSelf.friendPhoto = friendPhoto
            strongSelf.collectionView?.reloadData()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return friendPhoto.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FriendsPhotoCell", for: indexPath) as! FriendsPhotoCollectionViewCell
        cell.configure(withFriendImage: friendPhoto[indexPath.row])
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let bigPhoto = friendPhoto[indexPath.row].friendPhoto
        self.selectedIndexPath = indexPath
        userDefaults.set(bigPhoto, forKey: "bigPhoto")
    }
}

extension FriendsPhotoCollectionViewController: ZoomingViewController {
    func zoomingBackgroundView(for transition: ZoomTransitioningDelegate) -> UIView? {
        return nil
    }
    func zoomingImageView(for transition: ZoomTransitioningDelegate) -> UIImageView? {
        if let indexPath = selectedIndexPath {
            let cell = collectionView?.cellForItem(at: indexPath) as! FriendsPhotoCollectionViewCell
            return cell.images
        }
        return nil
    }
}
