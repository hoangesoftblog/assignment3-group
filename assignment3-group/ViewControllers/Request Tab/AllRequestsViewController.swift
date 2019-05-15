//
//  AllRequestsViewController.swift
//  
//
//  Created by Khánh Đặng on 5/8/19.
//

import UIKit
import Firebase

class Request {
    var owner: String?
    var imageName: String?
    var image: UIImage?
    var profilePic: UIImage?
    
    init(owner: String, image: UIImage?, imageName: String?, profilePic: UIImage?) {
        self.image = image
        self.imageName = imageName
        self.owner = owner
        self.profilePic = profilePic
    }
}

class AllRequestsViewController: UIViewController,UITableViewDelegate {
    var requestArray = [Int: Request]()
    let reuseIdentifier = "CellRequest"
    let fromRequestToPersonal = "fromRequestToPersonal"
    var temp: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem?.title = ""
//        navigationItem.rightBarButtonItem?.isEnabled = false
        var temp = [DataSnapshot]()
        print("View did load cua request")
        ref.child("userPicture/\(currentUser!)/RequestISentSomeone").observeSingleEvent(of: .value){ snapshot in
            var tempPic: UIImage?
            for i in snapshot.children {
                if let i2 = i as? DataSnapshot{
                    print("value of i2 is: ")
                    print(i2.value)
                    temp.append(i2)
                }
            }
            
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
                        
                        ref.child("userPicture/\(val["owner"]!)/avtImage" ?? "No picture").observeSingleEvent(of: .value){ snapshot in
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
                                            self.requestArray[i] = Request(owner: val["owner"] ?? "No owner", image: tempPic, imageName: val["image"] ?? "No image", profilePic: imageTemp)
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
    
    @IBOutlet weak var tableView: UITableView!
}

extension AllRequestsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("\(requestArray.count) requests available")
        return requestArray.count
    }
    
    @objc func goToSender(sender: UIButton) {
        print("Moving to sender")
        self.performSegue(withIdentifier: fromRequestToPersonal, sender: sender.currentTitle)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("Cell for row at indexpath \(indexPath.row) request")
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        
        if let customCell = cell as? RequestCell {
            temp = customCell.photo.frame.origin.y + customCell.photo.frame.height
            if indexPath.row < requestArray.count {
                print("Can return request cell at \(indexPath.row)")
                customCell.photo.image = requestArray[indexPath.row]?.image
                print("username is \(requestArray[indexPath.row]?.owner)")
                customCell.usernameButton.setTitle(requestArray[indexPath.row]?.owner, for: .normal)
                customCell.usernameButton.addTarget(self, action: #selector(goToSender(sender:)), for: .touchUpInside)
                
                
                print("Profile in Request is nil or not: \(requestArray[indexPath.row]?.profilePic == nil)")
                customCell.profilePic.image = requestArray[indexPath.row]?.profilePic
    
                return customCell
            }
            
            print("Can not return request cell")
        }
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == fromRequestToPersonal {
            if let dest = segue.destination as? MainPersonalViewController {
                if let temp_sender = sender as? String {
                    print("sender is \(temp_sender)")
                    dest.showingUser = temp_sender
                    dest.isLeftBarAbleToShow = false
                }
            }
        }
    }
    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        print(temp)
//        return (temp + 100)
//    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
                print(temp)
                return (temp + 100)
    }
    
}
