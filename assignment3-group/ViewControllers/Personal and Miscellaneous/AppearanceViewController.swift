//
//  AppearanceView.swift
//  assignment3-group
//
//  Created by Chau Phuoc Tuong on 5/8/19.
// https://stackoverflow.com/questions/27093226/changing-background-color-of-all-views-in-project-from-one-view-controller

import UIKit
import Foundation

class AppearanceView {
    
    class var sharedService : AppearanceView {
        struct Singleton {
            static let instance = AppearanceView()
        }
        return Singleton.instance
    }
    
    init() { }
    
    
    var backgroundColor : UIColor {
        get {
            var data: NSData? = UserDefaults.standard.object(forKey: "backgroundColor") as? NSData
            var returnValue: UIColor?
            if data != nil {
                returnValue = NSKeyedUnarchiver.unarchiveObject(with: data! as Data) as? UIColor
            } else {
                returnValue = UIColor(white: 1, alpha: 1);
            }
            return returnValue!
        }
        set (newValue) {
            let data = NSKeyedArchiver.archivedData(withRootObject: newValue)
            UserDefaults.standard.set(data, forKey: "backgroundColor")
            UserDefaults.standard.synchronize()
        }
    }
    func backgroundColorChanged(color : UIColor) {
        AppearanceView.sharedService.backgroundColor = color;
    }
    class AppearanceViewController: UIViewController {
        
        @IBOutlet weak var yellowButton: UIButton!
        
        @IBOutlet weak var yellowButtonTapped: UIButton!
        
        
        
        
        @IBOutlet weak var blackButton: UIButton!
        
        @IBAction func blackButtonTapped(_ sender: UIButton) {
        }
        
        
        
        
        override func viewDidLoad() {
            super.viewDidLoad()
        blackButton.layer.cornerRadius = blackButton.frame.height / 2.0
        blackButton.layer.masksToBounds = true
            
            
        yellowButton.layer.cornerRadius = yellowButton.frame.height / 2.0
        yellowButton.layer.masksToBounds = true
            self.view.backgroundColor = AppearanceView.sharedService.backgroundColor;
            
            // Do any additional setup after loading the view.
        }
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
