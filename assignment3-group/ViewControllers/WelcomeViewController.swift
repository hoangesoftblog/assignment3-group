//
//  WelcomeViewController.swift
//  AwesomePhoto
//
//  Created by Chau Phuoc Tuong on 4/16/19.
//  Copyright © 2019 Chau Phuoc Tuong. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var startButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let color = UserDefaults.standard.object(forKey: "bgColor") as? String else {
            return
        }
        if color == "yellow" {
            self.view.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
        }
        gradientBG()
        custommizeUI()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func startTapped(_ sender: Any) {
        
    }
    
    func gradientBG(){
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [UIColor(red: 238/255, green: 97/255, blue: 135/255, alpha: 1.0).cgColor, UIColor.white.cgColor]
        gradient.locations = [0.0 , 1.0]
        gradient.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradient.endPoint = CGPoint(x: 0.5, y: 0.0)
        gradient.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        
        self.view.layer.insertSublayer(gradient, at: 0)
    }
    
    func custommizeUI(){
        startButton.backgroundColor = .clear
        startButton.layer.cornerRadius = 18
        startButton.layer.borderWidth = 1
        startButton.layer.borderColor = UIColor.white.cgColor
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
