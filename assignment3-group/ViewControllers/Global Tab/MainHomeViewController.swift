//
//  MainHomeViewController.swift
//  AwesomePhoto
//
//  Created by Chau Phuoc Tuong on 4/21/19.
//  Copyright © 2019 Chau Phuoc Tuong. All rights reserved.
//

import UIKit
import Firebase

let ref: DatabaseReference = Database.database().reference()

class MainHomeViewController: UIViewController {
    var imageNames: [String] = []
    var imagePhoto: [Int: UIImage] = [:]
    var numberOfColumns: CGFloat = 2
    var selectedPicture: Int = 0
    
    let goToDetail = "showDetail"
    private let reuseIdentifier = "Cell"
    
    @IBOutlet weak var imageCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDataOnce()
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 120, height: 23))
        imageView.image = #imageLiteral(resourceName: "Image")
        navigationItem.titleView = imageView
        
        ref.child("fileName/chris-fowler-1203898-unsplash").observeSingleEvent(of: .value){ snapshot in
            if let temp = snapshot.value as? [String: String]{
                print("owner is \(temp["userID"])")
                print("extension is \(temp["extension"])")
            }
        }
    }
    
    //get data of all images from firebase
    func getDataOnce(){
        ref.child("publicPicture").observeSingleEvent(of: .value){ snapshot in
            for i in snapshot.children {
                if let i2 = (i as? DataSnapshot)?.value as? String {
                    self.imageNames.append(i2)
                }
            }
            
            self.imageCollection.reloadData()
            
            for i in 0..<self.imageNames.count {
                storageRef.child(self.imageNames[i]).getData(maxSize: INT64_MAX){ data, error in
                    //print(self.imageNames[i], separator: "", terminator: " ")
                    if error != nil {
                        //print("Error occurs")
                    }
                    else if data != nil {
                        if let imageTemp = UIImage(data: data!) {
                            //print("image available")
                            self.imagePhoto[i] = imageTemp
                        }
                    }
                    else {
                        //print("Data nil")
                    }
                    
                    self.imageCollection.reloadData()
                }
            }
        }
    }
}

extension MainHomeViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("\(imagePhoto.count) picture")
        return imagePhoto.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = imageCollection.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        
        if let photoViewCell = cell as? PhotoViewCell {
            if indexPath.row < imagePhoto.count{
                photoViewCell.imageView.image = imagePhoto[indexPath.row]
                return photoViewCell
            }
        }
        
        return cell
    }
}

extension MainHomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedPicture = indexPath.row
        performSegue(withIdentifier: goToDetail, sender: (imageNames[indexPath.row], imagePhoto[indexPath.row]))
    }
}

extension MainHomeViewController {
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                    withReuseIdentifier: "PhotoHeaderView", for: indexPath) as? PhotoCollectionHeaderView
            else {
                fatalError("Invalid view type")
            }
            
            if headerView.button1.isEnabled {
                //print("button 2 is pressed")
            }
            else if headerView.button2.isEnabled{
                //print("button 1 is pressed")
            }
            
            return headerView
            
        default:
            assert(false, "Invalid element type")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == goToDetail {
            if let dest = segue.destination as? DetailViewController {
                print(selectedPicture)
                if let (name, image) = sender as? (String, UIImage) {
                    dest.image = image
                    dest.fileName = name
                }
            }
        }
    }
}
