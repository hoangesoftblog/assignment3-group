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
    var imageName: String?
    var avtImage: UIImage?
    
    init(sender: String, imageName: String, image: UIImage?, time: String, avtImage: UIImage?) {
        self.sender = sender
        self.image = image
        self.time = time
        self.imageName = imageName
        self.avtImage = avtImage
    }
}

class MainPaymentViewController: UIViewController, UITableViewDelegate {
    let reuseIdentifier = "Cell"
    let goToPersonal = "fromPaymentToPersonal"
    var temp : CGFloat = 0
    @IBOutlet weak var tableView: UITableView!
    var notificationArray = [Int: Notif]()
    
    override func viewDidLoad() {
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 400
        var temp = [DataSnapshot]()
        super.viewDidLoad()
        print("Current user \(currentUser)")
        ref.child("userPicture/\(currentUser!)/requestSomeoneSentMe").observeSingleEvent(of: .value){ snapshot in
            var tempPic: UIImage?
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
                var avt: UIImage?
                if let val = temp[i].value as? [String: String]{
                    print("Getting on get picture")
                    storageRef.child(val["image"] ?? "No filename").getData(maxSize: INT64_MAX){ data, error in
                        if error != nil {
                            print("Error occurs")
                        }
                        else if data != nil {
                            if let imageTemp = UIImage(data: data!) {
                                print("image in payment available")
                                tempPic = imageTemp
                            }
                        }
                        
                        ref.child("userPicture/\(val["sender"]!)/avtImage" ?? "No picture").observeSingleEvent(of: .value){ snapshot in
                            print("\nsnapshot is \(snapshot), ref is \(snapshot.ref)\n")
                            if let avtFileName = snapshot.value as? String {
                                print("Can get the value \(avtFileName)")
                                storageRef.child(avtFileName ).getData(maxSize: INT64_MAX){ data, error in
                                    if error != nil {
                                        print("Error occurs")
                                    }
                                    else if data != nil {
                                        if let imageTemp = UIImage(data: data!) {
                                            print("avt image in payment available")
                                            self.notificationArray[i] = Notif(sender: val["sender"] ?? "No sender", imageName: val["image"] ?? "No filename", image: tempPic, time: val["time"] ?? "No time", avtImage: imageTemp)
                                            self.tableView.reloadData()
                                            
                                        }
                                    }
                                }
                            }
                        }
                        
                        
                    }
                }
            
            }
            
        }
        
    }
}

extension MainPaymentViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("There are \(notificationArray.count) notifications")
        return notificationArray.count
    }
    
    @objc func denyPic(sender: UIButton){
        let val = sender.tag
        notificationArray[val] = nil
        
        if self.tableView.numberOfRows(inSection: 0) == 1 {
            if let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)){
                if let customCell = cell as? PaymentCell {
                    customCell.usernameButton.isHidden = true
                    customCell.timeLabel.isHidden = true
                    customCell.timeLabel.text = ""
                    customCell.acceptButton.isHidden = true
                    customCell.denyButton.isHidden = true
                    customCell.contactButton.isHidden = true
                    customCell.photo.isHidden = true
                    customCell.sendRequestLabel.text = "No notification"
                }
            }
            else {
                print("Cell is nil")
            }
        }
        else {
            self.tableView.deleteRows(at: [IndexPath(row: val, section: 0)], with: .left)
        }
        print("There are \(self.tableView.numberOfRows(inSection: 0)) table row after pressing button")
        
    }
    
    @objc func acceptPic(sender: UIButton){
        let val = sender.tag
        
        ref.child("fileName/\(Media.removeFileExtension(file: (notificationArray[val]?.imageName ?? "Not available")))/SharedWithoutWatermark").childByAutoId().setValue(currentUser!)
        
        ref.child("userPicture/\(notificationArray[val]?.sender)").child("fileSharedWithoutWatermark").childByAutoId().setValue((notificationArray[val]?.imageName ?? "Not available"))
        
        ref.child("userPicture")
        
        denyPic(sender: sender)
    }
    
    @objc func contactOwner(sender: UIButton) {
        print("Contacting")
        self.performSegue(withIdentifier: goToPersonal, sender: sender.accessibilityIdentifier)
    }
    
    @objc func goToSender(sender: UIButton) {
        print("Moving to sender")
        self.performSegue(withIdentifier: goToPersonal, sender: sender.currentTitle)
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
//        if let customCell = cell as? PaymentCell{
//           temp = customCell.timeLabel.frame.origin.y + 30
//        }
//            return temp
//
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("Cell for row at start working")
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        
        if let customCell = cell as? PaymentCell {
           // temp = customCell.timeLabel.frame.origin.y + customCell.timeLabel.font.ascender
            temp = customCell.photo.frame.origin.y + customCell.photo.frame.height
            if indexPath.row < notificationArray.count {
                print("Can return payment cell at \(indexPath.row)")
                customCell.photo.image = notificationArray[indexPath.row]?.image
                print("username is \(notificationArray[indexPath.row]?.sender)")
                
                customCell.usernameButton.setTitle(notificationArray[indexPath.row]?.sender, for: .normal)
                customCell.usernameButton.addTarget(self, action: #selector(goToSender(sender:)), for: .touchUpInside)
                
                customCell.timeLabel.text = notificationArray[indexPath.row]?.time
                
                customCell.acceptButton.tag = indexPath.row
                customCell.acceptButton.addTarget(self, action: #selector(acceptPic(sender:)), for: .touchUpInside)
                
                customCell.denyButton.tag = indexPath.row
                customCell.denyButton.addTarget(self, action: #selector(denyPic(sender:)), for: .touchUpInside)
                
                customCell.contactButton.accessibilityIdentifier = notificationArray[indexPath.row]?.sender
                customCell.contactButton.addTarget(self, action: #selector(contactOwner(sender:)), for: .touchUpInside)
                
                
                customCell.profilePicture.image = notificationArray[indexPath.row]?.avtImage
                return customCell
            }            
            
            print("Can not return payment cell")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (temp + 100)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == goToPersonal {
            if let dest = segue.destination as? MainPersonalViewController {
                if let temp_sender = sender as? String {
                    dest.showingUser = temp_sender
                    dest.isLeftBarAbleToShow = false
                }
            }
        }
    }
}

//extension MainPaymentViewController: UITableViewDelegate {
//    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
//    {
//        return 400;//Your custom row height
//    }
//}
