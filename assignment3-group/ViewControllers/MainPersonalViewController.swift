//
//  MainPersonalController.swift
//  SideMenu
//
//  Created by namtranx on 4/20/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

private let reuseIdentifier = "personalCollectionViewCell"
var cellWidth: CGFloat = 0
var cellHeight: CGFloat = 0

class MainPersonalViewController: UIViewController{
    
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var avtImageView: UIImageView!
    
    @IBOutlet weak var uploadPhotoImageView: UIImageView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    @IBOutlet weak var sideViewLeadingContraint: NSLayoutConstraint!
    
    var menuShowing:Bool = false
    
    var arrImages: [String] = ["tutorial-1","tutorial-1","tutorial-1","tutorial-1","tutorial-1","tutorial-1","tutorial-1","tutorial-1","tutorial-1","tutorial-1","tutorial-1","tutorial-1","tutorial-1","tutorial-1","tutorial-1","tutorial-1","tutorial-1","tutorial-1","tutorial-1","tutorial-1","tutorial-1","tutorial-1"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        collectionView.delegate = self
        collectionView.dataSource = self
    
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        cellWidth = self.collectionView.bounds.size.width
        cellHeight = self.collectionView.bounds.size.height
    }
    
    func updateUI(){
        
        avtImageView.layer.cornerRadius = avtImageView.frame.height / 2.0
        avtImageView.layer.masksToBounds = true
        uploadPhotoImageView.layer.cornerRadius = uploadPhotoImageView.frame.height/2
        uploadPhotoImageView.layer.masksToBounds = true
        
    }
    
    @IBAction func toggledTapped(_ sender: Any) {
        if menuShowing{
            sideViewLeadingContraint.constant = -140
        }else{
            sideViewLeadingContraint.constant = 0
        }
        
        UIView.animate(withDuration: 0.2, delay: 0, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
        
        menuShowing = !menuShowing
        
    }
    
    

}

extension MainPersonalViewController:  UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellWidth/2, height: cellHeight/2)
    }
    
    
}

extension MainPersonalViewController: UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! UICollectionViewCell
        let imgView = cell.viewWithTag(100) as! UIImageView
        imgView.image = UIImage(named: arrImages[indexPath.row])
        return cell
    }
    
    
}
