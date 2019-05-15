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
    let sectionInsets = UIEdgeInsets(top: 50.0,
                                     left: 20.0,
                                     bottom: 50.0,
                                     right: 20.0)
    var fileName: [String] = []
    var imagePhoto: [Int: UIImage] = [:]
    var numberOfColumns: CGFloat = 2
    
    let PublicToDetail = "PublicToDetail"
    private let pictureCellReuse = "pictureCell"
    private let videoCellReuse = "videoCell"
    
    let refreshControl = UIRefreshControl()
    @IBOutlet weak var imageCollection: UICollectionView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        getDataOnce()
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 120, height: 23))
        imageView.image = #imageLiteral(resourceName: "awesome")
        navigationItem.titleView = imageView
        
        if #available(iOS 10.0, *) {
            self.imageCollection.refreshControl = refreshControl
        } else {
            self.imageCollection.addSubview(refreshControl)
        }
        
        refreshControl.addTarget(self, action: #selector(refreshView), for: .valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "Reloading")
        loadTotalFileUsed()
    }
    
    @objc func refreshView(){
        print("\n\nrefresing view working\n\n")
        imagePhoto.removeAll()
        fileName.removeAll()
        getDataOnce()
        
    }
    
    func loadTotalFileUsed(){
        
        ref.child("userPicture/\(currentUser!)/fileOwned").observeSingleEvent(of: .value){ snapshot in
            print(snapshot.value)
            for i in snapshot.children {
                print("Inside first loop")
                if let i2 = (i as? DataSnapshot)?.value as? String {
                    print("Inside second loop, i2 is \(i2)")
                    
                    storageRef.child(i2).getMetadata{ metadata, error in
                        if error != nil {
                            print("file name \(i2) get metadata error \(error?.localizedDescription)")
                        }
                        else {
                            print("file name \(i2) has the size of \(metadata?.size)")
                        }
                        print("file name \(i2) has the size of \(metadata?.size)")
                    }
                }
                else {
                    print("Invalid path")
                }
            }
        }
    }
    
    //get data of all images from firebase
    func getDataOnce(){
        ref.child("publicPicture").observeSingleEvent(of: .value){ snapshot in
            for i in snapshot.children {
                if let i2 = (i as? DataSnapshot)?.value as? String {
                    self.fileName.append(i2)
                }
            }
            
            self.imageCollection.reloadData()
            
            let val = self.fileName.count - 1
            if val >= 0 {
                for i in 0...val {
                    storageRef.child(self.fileName[i]).getData(maxSize: INT64_MAX){ data, error in
                        print(self.fileName[i], separator: "", terminator: " ")
                        if error != nil {
                            print("Error occurs")
                        }
                        else if data != nil {
                            if let imageTemp = UIImage(data: data!) {
                                print("image available")
                                self.imagePhoto[val - i] = imageTemp
                            }
                        }
                        
                        if self.imagePhoto.count == self.fileName.count{
                            self.refreshControl.endRefreshing()
                        }
                        
                        self.imageCollection.reloadData()
                    }
                }
            }
            else {
                self.refreshControl.endRefreshing()
            }

            
            
            
        }
    }
}

extension MainHomeViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        print("number of sections")
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("\(imagePhoto.count) picture")
        return imagePhoto.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if (!fileName[indexPath.row].contains("thumbnail")) {
            let cell = imageCollection.dequeueReusableCell(withReuseIdentifier: pictureCellReuse, for: indexPath)
            
            if let photoViewCell = cell as? PhotoViewCell {
                if indexPath.row < imagePhoto.count{
                    photoViewCell.imageView.image = imagePhoto[indexPath.row] as? UIImage
                    return photoViewCell
                }
            }
            
            return cell
        }
        else {
            let cell = imageCollection.dequeueReusableCell(withReuseIdentifier: videoCellReuse, for: indexPath)
            
            if let videoViewCell = cell as? VideoViewCell {
                if indexPath.row < imagePhoto.count{
                    videoViewCell.thumbnailView.image = imagePhoto[indexPath.row] as? UIImage
                    return videoViewCell
                }
            }
            
            return cell
        }
    }
}

extension MainHomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("image choosen is \(fileName[indexPath.row])")
        performSegue(withIdentifier: PublicToDetail, sender: (fileName[fileName.count - 1 - indexPath.row], imagePhoto[indexPath.row]))
    }
}

extension MainHomeViewController {
    @objc func bt1Click(){
        numberOfColumns = 2
        self.imageCollection.reloadData()
    }
    
    @objc func bt2Click(){
        numberOfColumns = 1
        self.imageCollection.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                    withReuseIdentifier: "PhotoHeaderView", for: indexPath) as? PhotoCollectionHeaderView
            else {
                fatalError("Invalid view type")
            }
            headerView.layer.borderWidth = 5
            
            headerView.button1.addTarget(self, action: #selector(bt1Click), for: .touchUpInside)
            
            headerView.button2.addTarget(self, action: #selector(bt2Click), for: .touchUpInside)

            return headerView

        default:
            assert(false, "Invalid element type")
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == PublicToDetail {
            if let dest = segue.destination as? DetailViewController {
                if let (name, image) = sender as? (String, UIImage) {
                    dest.image = image
                    dest.fileName = name
                }
            }
        }
    }
}

extension MainHomeViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (numberOfColumns + 1)
        let available = view.frame.width - paddingSpace
        let widthPerItem = available / numberOfColumns

        //print("IndexPath row is \(indexPath.row)")
        //print("imagePhoto has \(imagePhoto.count)\n")
        if indexPath.row < imagePhoto.count && imagePhoto[indexPath.row] != nil {
            //print("\(photoHeight)\t\(photoWidth)")

            return CGSize(width: widthPerItem, height: widthPerItem * ((imagePhoto[indexPath.row]?.size.height)! / (imagePhoto[indexPath.row]?.size.width)!))
        }
        else {
            return CGSize(width: widthPerItem, height: widthPerItem)
        }

    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }

    // 4
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
}
