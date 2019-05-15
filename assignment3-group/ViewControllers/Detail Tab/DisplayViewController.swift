//
//  DisplayViewController.swift
//  assignment3-group
//
//  Created by vang huynh minh tri on 5/14/19.
//  Copyright © 2019 Hoang, Truong Quoc. All rights reserved.
//

import Foundation
import UIKit

class DisplayViewController : UIViewController {
    var image : UIImage?
    var fileName : String?
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        
        imageView.image = image
        imageView.frame = UIScreen.main.bounds
        imageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissDisplay(sender:)))
        imageView.addGestureRecognizer(tap)
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
        super.viewDidLoad()
    }
    
    @objc func dismissDisplay(sender:UITapGestureRecognizer){
        performSegue(withIdentifier: "BackToDetail", sender: (fileName,imageView.image))
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "BackToDetail"{
            if let dest = segue.destination as? DetailViewController {
                if let (filename,image) = sender as? (String?,UIImage?){
                    dest.fileName = fileName
                    dest.image = image
                }
            }
        }
    }
}
