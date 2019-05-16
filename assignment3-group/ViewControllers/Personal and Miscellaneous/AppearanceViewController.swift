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
}

class AppearanceViewController: UIViewController {
    
    
    
    
//    @IBAction func boundedImage(_ sender: Any) {
//        .layer.cornerRadius = grayButton.frame.height / 2.0
//        self.layer.masksToBounds = true
//        self.view.backgroundColor = AppearanceView.sharedService.backgroundColor;
//    }
    
    @IBOutlet weak var yellowButton: UIButton!
    @IBAction func yellowButtonTapped(_ sender: UIButton) {
        UserDefaults.standard.set("yellow", forKey: "bgColor")
        guard let color: String = UserDefaults.standard.object(forKey: "bgColor") as? String else {return}
        if color == "yellow" {
            self.view.backgroundColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
        }
    }
     @IBOutlet weak var grayButton: UIButton!
    
    @IBAction func grayButtonTapped(_ sender: Any) {
        UserDefaults.standard.set("gray", forKey: "bgColor")
        guard let color: String = UserDefaults.standard.object(forKey: "bgColor") as? String else {return}
        if color == "gray" {
            self.view.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        }
    }
    
    @IBOutlet weak var pinkButton: UIButton!
    
    
    @IBAction func pinkButtonTapped(_ sender: Any) {
        UserDefaults.standard.set("pink", forKey: "bgColor")
        guard let color: String = UserDefaults.standard.object(forKey: "bgColor") as? String else {return}
        if color == "pink" {
            self.view.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        }
    }
    
 
    
    @IBOutlet weak var greenButton: UIButton!
    
    @IBAction func greenButtonTapped(_ sender: Any) {
        UserDefaults.standard.set("green", forKey: "bgColor")
        guard let color: String = UserDefaults.standard.object(forKey: "bgColor") as? String else {return}
        if color == "green" {
            self.view.backgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
        }
    }
    
    
    @IBOutlet weak var whiteButton: UIButton!
    
    @IBAction func whiteButtonTapped(_ sender: Any) {
        UserDefaults.standard.set("white", forKey: "bgColor")
        guard let color: String = UserDefaults.standard.object(forKey: "bgColor") as? String else {return}
        if color == "white" {
            self.view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        yellowButton.layer.cornerRadius = yellowButton.frame.height / 2.0
        yellowButton.layer.masksToBounds = true
        self.view.backgroundColor = AppearanceView.sharedService.backgroundColor
        
        UserDefaults.standard.set("yellow", forKey: "bgColor")
        guard let color: String = UserDefaults.standard.object(forKey: "bgColor") as? String else {return}
        if color == "yellow" {
            self.view.backgroundColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
        }
        
        
        whiteButton.layer.cornerRadius = whiteButton.frame.height / 2.0
        whiteButton.layer.masksToBounds = true
        self.view.backgroundColor = AppearanceView.sharedService.backgroundColor
        
        UserDefaults.standard.set("yellow", forKey: "bgColor")
        guard let white: String = UserDefaults.standard.object(forKey: "bgColor") as? String else {return}
        if color == "white" {
            self.view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
        
        
        pinkButton.layer.cornerRadius = pinkButton.frame.height / 2.0
        pinkButton.layer.masksToBounds = true
        self.view.backgroundColor = AppearanceView.sharedService.backgroundColor;
        
        
        grayButton.layer.cornerRadius = grayButton.frame.height / 2.0
        grayButton.layer.masksToBounds = true
        self.view.backgroundColor = AppearanceView.sharedService.backgroundColor;
        
        
        greenButton.layer.cornerRadius = greenButton.frame.height / 2.0
        greenButton.layer.masksToBounds = true
        self.view.backgroundColor = AppearanceView.sharedService.backgroundColor
        
        UserDefaults.standard.set("green", forKey: "bgColor")
        guard let green: String = UserDefaults.standard.object(forKey: "bgColor") as? String else {return}
        if color == "green" {
            self.view.backgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
        }
        
        
        
        

        // Do any additional setup after loading the view.
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




        
        
        
    
        
        
        

