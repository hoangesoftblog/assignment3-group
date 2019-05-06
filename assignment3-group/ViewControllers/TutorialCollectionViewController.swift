//
//  TutorialCollectionViewController.swift
//  AwesomePhoto
//
//  Created by Chau Phuoc Tuong on 4/16/19.
//  Copyright © 2019 Chau Phuoc Tuong. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class TutorialCollectionViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    var cellWidth: CGFloat = 0
    var cellHeight: CGFloat = 0
    
    var imageArr: [String] = ["tutorial-1","tutorial-2","tutorial-3"]

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        pageControl.currentPage = 0
        pageControl.numberOfPages = 3
        pageControl.pageIndicatorTintColor = .black
        pageControl.currentPageIndicatorTintColor = .red
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        cellWidth = self.collectionView.bounds.size.width
        cellHeight = self.collectionView.bounds.size.height
    }
    
    @IBAction func backTapped(_ sender: Any) {
        
    }
    
    
    @IBAction func nextTapped(_ sender: Any) {
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TutorialCollectionViewCell
        cell.imageView.image = UIImage(named: imageArr[indexPath.row])
        pageControl.currentPage = indexPath.row
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellWidth , height: cellHeight )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}
