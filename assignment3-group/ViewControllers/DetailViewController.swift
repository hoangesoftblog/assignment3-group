//
//  DetailViewController.swift
//  assignment3-group
//
//  Created by Hoang, Truong Quoc on 5/1/19.
//  Copyright © 2019 Hoang, Truong Quoc. All rights reserved.
//

import UIKit
import Firebase

class DetailViewController: UIViewController {
    
    var fileName: String?
    var insetLeft: CGFloat = 20
    var insetTop: CGFloat = 20
    var image: UIImage?
    var database: DatabaseReference?
    
    let selectPerson = "DetailToSelectPerson"
    
    @IBOutlet weak var mainPic: UIImageView!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var usernameButton: UIButton!
    
    override func viewDidLoad() {
        database = Database.database().reference()
        super.viewDidLoad()
        mainPic.image = image
        database?.child("fileName/\(Media.removeFileExtension(file: fileName!))").observeSingleEvent(of: .value){ snapshot in
            if let val = snapshot.value as? [String: Any]{
                self.usernameButton.setTitle((val["owner"] as? String) ?? "Not available", for: .normal)
            }
        }
        
    }
    
    @IBAction func pictureAction(_ sender: Any) {
        let action = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        
        if currentUser == self.usernameButton.titleLabel?.text! {
            action.addAction(UIAlertAction(title: "Shared with someone", style: .default) { (_) in
                
                self.performSegue(withIdentifier: self.selectPerson, sender: (self.usernameButton.titleLabel?.text!, self.fileName!))
                
            })
        }
        else {
            action.addAction(UIAlertAction(title: "Not the owner so no sharing", style: .default
                , handler: nil))
        }
        
        action.addAction(UIAlertAction(title: "Dismiss", style: .cancel) { (_) in
            print("Return to normal")
        })
        
        present(action, animated: true, completion: nil)
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == selectPerson {
            if let temp = segue.destination as? SelectPersonViewController {
                if let (owner, fileName) = sender as? (String, String){
                    temp.owner = owner
                    temp.fileName = fileName
                }
            }
        }
    }
    
    let backToLogin = "backToLogin"
    @IBAction func logOut(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            self.dismiss(animated: true, completion: nil)
        }
        catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
}
