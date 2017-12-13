//
//  NewPostViewController.swift
//  VKclient_Kirillov_Anton
//
//  Created by Антон Кириллов on 14.11.2017.
//  Copyright © 2017 Barpost. All rights reserved.
//

import UIKit
import CoreLocation
import SwiftyJSON

class NewPostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var toolBarView: UIView!
    @IBOutlet weak var textOfPostView: UITextField!
    @IBOutlet weak var postButtonOutlet: UIButton!
    @IBOutlet weak var settingButtonOutlet: UIButton!
    @IBOutlet weak var geoPinButtonOutlet: UIButton!
    @IBOutlet weak var addFriendButtonOutlet: UIButton!
    @IBOutlet weak var addPhotoButtonOutlet: UIButton!
    @IBOutlet weak var locationOfUserOutlet: UILabel!
    @IBOutlet weak var lockedPostOutlet: UIImageView!
    
    var coordForPost: (Double, Double)?
    var imageToPostFromLibrary: UIImage?
    var getMyPostToWall: GetMyPostToWall?
    var addFriend = ""
    
    @IBAction func addPhotoToPost(_ sender: UIButton) {
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.photoLibrary
        image.allowsEditing = false
        self.present(image, animated: true) {
            print("YO it is complete")
        }
    }
    
    func myImageUploadRequest(serverUrl: String) { 
        let myUrl = NSURL(string: serverUrl)
        let request = NSMutableURLRequest(url:myUrl! as URL)
        request.httpMethod = "POST"
        let param = [
            "firstName"  : "Anton",
            ]
        let boundary = generateBoundaryString()
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        let imageData = UIImageJPEGRepresentation(imageToPostFromLibrary!, 1)
        if (imageData == nil)  { return }
        request.httpBody = createBodyWithParameters(parameters: param, filePathKey: "file", imageDataKey: imageData! as NSData, boundary: boundary) as Data
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            if error != nil {
                print("error=\(String(describing: error))")
                return
            }
            do {
                let data = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                let json = JSON(data!)
                APIService.shared.saveWallPhotoToVkServer(
                photo: json["photo"].stringValue,
                server: json["server"].stringValue,
                hash: json["hash"].stringValue) { [weak self] completion in
                    DispatchQueue.main.async {
                        APIService.shared.newPost(
                            message: (self?.textOfPostView.text!)! + (self?.addFriend)!,
                            onlyForFriends: userDefaults.integer(forKey: "onlyForFriends"),
                            geo: self?.coordForPost,
                            attachments: completion)
                        self?.performSegue(withIdentifier: "unwindFromAddNewPostToNewsFeed", sender: self)
                    }
                }
                DispatchQueue.main.async {
                    self.imageToPostFromLibrary = nil
                }
            } catch {
                print(error)
            }
        }
        task.resume()
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageToPostFromLibrary = image
            if imageToPostFromLibrary != nil || coordForPost != nil || !(textOfPostView.text?.isEmpty)! {
                postButtonOutlet.isEnabled = true
                addPhotoButtonOutlet.setImage(UIImage(named: "addPhotoON"), for: .normal)
            } else {
                postButtonOutlet.isEnabled = false
            }
        } else {
            print("ERROR IN IMAGE TO POST")
        }
        self.dismiss(animated: true, completion: nil)
    }
    func createBodyWithParameters(parameters: [String: String]?, filePathKey: String?, imageDataKey: NSData, boundary: String) -> NSData {
        let body = NSMutableData();
        if parameters != nil {
            for (key, value) in parameters! {
                body.appendString(string: "--\(boundary)\r\n")
                body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString(string: "\(value)\r\n")
            }
        }
        let filename = "user-profile.jpg"
        let mimetype = "image/jpg"
        body.appendString(string: "--\(boundary)\r\n")
        body.appendString(string: "Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
        body.appendString(string: "Content-Type: \(mimetype)\r\n\r\n")
        body.append(imageDataKey as Data)
        body.appendString(string: "\r\n")
        body.appendString(string: "--\(boundary)--\r\n")
        return body
    }
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
    @IBAction func unwindFromMapKit(segue: UIStoryboardSegue) { //Добавить отмену добавления локации
        let source = segue.source as! AddGeoController
        self.coordForPost = source.coordForPost
        if self.coordForPost != nil {
            self.geoPinButtonOutlet.setImage(UIImage(named: "addGeoPinON"), for: .normal)
            self.locationOfUserOutlet.isHidden = false
            self.locationOfUserOutlet.text = source.nameOfLocation
        }
        if !(textOfPostView.text?.isEmpty)! || coordForPost != nil || imageToPostFromLibrary != nil {
            postButtonOutlet.isEnabled = true
        } else {
            postButtonOutlet.isEnabled = false
        }
    }
    @IBAction func unwindFromSettingsToNewPost(segue: UIStoryboardSegue) {
        if userDefaults.integer(forKey: "onlyForFriends") == 1 {
            settingButtonOutlet.setImage(UIImage(named: "addSettingON"), for: .normal)
            lockedPostOutlet.isHidden = false
        } else {
            settingButtonOutlet.setImage(UIImage(named: "addSettingOFF"), for: .normal)
            lockedPostOutlet.isHidden = true
        }
    }
    
    @IBAction func unwindFromAddFriendToNewPost(segue: UIStoryboardSegue) {
        if segue.identifier == "unwindFromAddFriendToNewPost" {
            let addFriendsTableViewController = segue.source as! AddFriendsTableViewController
            if let indexPath = addFriendsTableViewController.tableView.indexPathForSelectedRow {
                let friend = addFriendsTableViewController.friends![indexPath.row]
                let friendID = friend.friendID
                let friendName = "\(friend.firstname) \(friend.lastname)"
                addFriend = " *id\(friendID) (\(friendName))"
                if friendName != "" {
                    addFriendButtonOutlet.setImage(UIImage(named: "addFriendON"), for: .normal)
                }
            }
        }
    }
    
    @IBAction func postButton(_ sender: Any) {
        DispatchQueue.main.async {
            if self.imageToPostFromLibrary != nil {
                APIService.shared.getWallUploadServer { [weak self] completion in
                    self?.getMyPostToWall = completion
                    self?.myImageUploadRequest(serverUrl: (self?.getMyPostToWall?.serverUpload_url)!)
                }
            } else {
                let text = self.textOfPostView.text! + self.addFriend
                APIService.shared.newPost(
                    message: text,
                    onlyForFriends: userDefaults.integer(forKey: "onlyForFriends"),
                    geo: self.coordForPost,
                    attachments: nil)
                self.performSegue(withIdentifier: "unwindFromAddNewPostToNewsFeed", sender: self)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userDefaults.set(0, forKey: "onlyForFriends")
        textOfPostView.delegate = self
        if (textOfPostView.text?.isEmpty)! {
            postButtonOutlet.isEnabled = false
        }
        textOfPostView.inputAccessoryView = toolBarView
        textOfPostView.becomeFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        textOfPostView.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
extension NewPostViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (range.location == 0 && range.length == 0) {
            postButtonOutlet.isEnabled = true
        } else if (range.location == 0 && range.length == 1) && coordForPost == nil && imageToPostFromLibrary == nil {
            postButtonOutlet.isEnabled = false
        }
        return true
    }
}
extension NSMutableData {
    func appendString(string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}
