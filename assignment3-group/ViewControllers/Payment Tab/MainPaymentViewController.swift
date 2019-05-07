//
//  MainPaymentViewController.swift
//  AwesomePhoto
//
//  Created by Chau Phuoc Tuong on 4/21/19.
//  Copyright © 2019 Chau Phuoc Tuong. All rights reserved.
//

import UIKit
import Firebase

class Notif {
    var sender: String?
    var image: UIImage?
    var time: String?
    
    init(sender: String, image: UIImage, time: String) {
        self.sender = sender
        self.image = image
        self.time = time
    }
}

class MainPaymentViewController: UIViewController,UITableViewDelegate {
    let reuseIdentifier = "Cell"
    var temp : CGFloat = 0
    @IBOutlet weak var tableView: UITableView!
    var notificationArray = [Int: Notif]()
    
    override func viewDidLoad() {
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 400
        var temp = [DataSnapshot]()
        super.viewDidLoad()
        
        print(currentUser!)
        ref.child("userPicture/\(currentUser!)/notification").observeSingleEvent(of: .value){ snapshot in
            print("On first completion")
            print(snapshot.value)
            for i in snapshot.children {
                print("In 1st for loop")
                if let i2 = i as? DataSnapshot{
                    print("value of i2 is: ")
                    print(i2.value)
                    temp.append(i2)
                }
            }
            
            print("Reload data 1st, temp has \(temp.count)")
            self.tableView.reloadData()
            
            for i in 0..<temp.count {
                if let val = temp[i].value as? [String: String]{
                    print("Getting on get picture")
                    storageRef.child(val["image"] ?? "").getData(maxSize: INT64_MAX){ data, error in
                        if error != nil {
                            print("Error occurs")
                        }
                        else if data != nil {
                            if let imageTemp = UIImage(data: data!) {
                                print("image in payment available")
                                self.notificationArray[i] = Notif(sender: val["sender"] ?? "No sender", image: imageTemp, time: val["time"] ?? "No time")
                            }
                        }
                        
                        self.tableView.reloadData()
                    }
                }
            
            }
            
        }
        
    }
}

extension MainPaymentViewController: UITableViewDataSource {
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
//        if let customCell = cell as? PaymentCell{
//           temp = customCell.timeLabel.frame.origin.y + 30
//        }
//            return temp
//
//    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("There are \(notificationArray.count) notifications")
        return notificationArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("Cell for row at start working")
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        
        if let customCell = cell as? PaymentCell {
           // temp = customCell.timeLabel.frame.origin.y + customCell.timeLabel.font.ascender
            temp = customCell.photo.frame.origin.y + customCell.photo.frame.height
            if indexPath.row < notificationArray.count {
                print("Can return payment cell")
                customCell.photo.image = notificationArray[indexPath.row]?.image
                customCell.usernameButton.titleLabel?.text = notificationArray[indexPath.row]?.sender
                customCell.timeLabel.text = notificationArray[indexPath.row]?.time
                
                return customCell
            }            
            
            print("Can not return payment cell")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (temp + 60)
    }
}

//extension MainPaymentViewController: UITableViewDelegate {
//    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
//    {
//        return 400;//Your custom row height
//    }
//}
