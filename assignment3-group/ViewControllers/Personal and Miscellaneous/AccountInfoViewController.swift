//
//  AccountInfoViewController.swift
//  assignment3-group
//
//  Created by Bui Thanh Khoi on 5/15/19.
//  Copyright © 2019 Hoang, Truong Quoc. All rights reserved.
//

import UIKit
import Firebase

class AccountInfoViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var BioTextfield: UITextField!
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //AwesomePhoto logo at the center of navigaton bar
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 120, height: 23))
        imageView.image = #imageLiteral(resourceName: "awesome")
        navigationItem.titleView = imageView
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(finishEditing))
    }
    
    @objc func finishEditing() {
        print("Button is pressed")
        
        if !(nameTextField.text?.isEmpty)! {
            print("nameTextField is working, nametextFiekld is \(nameTextField.text)")
            ref.child("userPicture/\(currentUser!)").observeSingleEvent(of: .value) { snapshot in
                let data = snapshot.value
                //Transfer data from old to new node
                
                snapshot.ref.parent?.child(self.nameTextField.text!).setValue(data)
                print("Inside nametextfield 2")
               
               print(Auth.auth().currentUser?.uid)
                snapshot.ref.root.child("IDToUser/\(Auth.auth().currentUser!.uid)").setValue(self.nameTextField.text!)
                
                for i in snapshot.childSnapshot(forPath: "fileOwned").children {
                    if let i2 = (i as? DataSnapshot)?.value as? String {
                        
                        print("Inside nametextfield 3")
                        snapshot.ref.root.child("fileName/\(Media.removeFileExtension(file: i2))/owner").setValue(self.nameTextField.text!)
                    }
                }
                
                for i in snapshot.childSnapshot(forPath: "Public").children {
                    if let i2 = (i as? DataSnapshot)?.value as? String {
                        print("Inside nametextfield 4")

                        snapshot.ref.root.child("fileName/\(Media.removeFileExtension(file: i2))/owner").setValue(self.nameTextField.text!)
                    }
                }
                
                currentUser = self.nameTextField.text!
                snapshot.ref.setValue(nil)
            }
        }
        
        if !(BioTextfield.text?.isEmpty)! {
            print("BioTextField is working, biotextfield is \(BioTextfield.text)")
            ref.child("userPicture/\(((self.nameTextField.text)?.isEmpty)! ? currentUser! : self.nameTextField.text!)/Bio").setValue(BioTextfield.text!)
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
