//
//  SelectPersonViewController.swift
//  assignment3-group
//
//  Created by hoang on 5/4/19.
//  Copyright © 2019 Hoang, Truong Quoc. All rights reserved.
//

import UIKit
import Firebase

class SelectPersonViewController: UITableViewController, UISearchBarDelegate {
    enum nameOfArray: Int {
        case canShare, shared
    }
    var info: [[String]] = [[String]](repeating: [], count: 2)
    var owner: String?
    var fileName: String?
    let reuseIdentifier = "Cell"
    var filterData = [String]()
    var searchBar = UISearchBar()

    override func viewDidLoad() {
        super.viewDidLoad()
        //O is Can share

        ref.child("IDToUser").observeSingleEvent(of: .value){ snapshot in
            for i in snapshot.children {
                if let i2 = (i as? DataSnapshot)?.value as? String {
                    if i2 != self.owner {
                        self.info[nameOfArray.canShare.rawValue].append(i2)
                    }
                }
            }
            self.filterData = self.info[nameOfArray.canShare.rawValue]
            self.tableView.reloadData()
        }
        
        navigationItem.titleView = searchBar
        searchBar.delegate = self
        
        
        //1 is Shared to
        ref.child("fileName/\(Media.removeFileExtension(file: fileName!))/Shared").observeSingleEvent(of: .value){ snapshot in
            for i in snapshot.children {
                if let i2 = (i as? DataSnapshot)?.value as? String {
                    if i2 != self.owner {
                        self.info[nameOfArray.shared.rawValue].append(i2)
                    }
                }
            }
            
            self.tableView.reloadData()
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return info.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == nameOfArray.canShare.rawValue {
            return filterData.count
        }
        else {
            return info[section].count
        }
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)

         //Configure the cell...
        if indexPath.section == nameOfArray.canShare.rawValue {
            cell.textLabel?.text = filterData[indexPath.row]
        }
        else {
            cell.textLabel?.text = info[indexPath.section][indexPath.row]
        }
        

        return cell
    }
 

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterData = searchText.isEmpty ? info[nameOfArray.canShare.rawValue] : info[nameOfArray.canShare.rawValue].filter { (item: String) -> Bool in
            // If dataItem matches the searchText, return true to include it
            return item.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }
        
        tableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
        self.searchBar.showsScopeBar = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = false
        self.searchBar.text = ""
        self.searchBar.resignFirstResponder()
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var res: String?
        if let array = nameOfArray(rawValue: section){
            switch array {
                case .canShare:
                    res = "People you can share"
                case .shared:
                    res = "Already shared to: "
            }
        }
        return res
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == nameOfArray.canShare.rawValue {
            ref.child("userPicture/\(self.info[indexPath.section][indexPath.row])/fileSharedWithWatermark").childByAutoId().setValue(self.fileName)
            ref.child("fileName/\(Media.removeFileExtension(file: fileName!))/Shared").childByAutoId().setValue(self.info[indexPath.section][indexPath.row])
            self.navigationController?.popViewController(animated: true)
            dismiss(animated: true, completion: nil)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("Search button click")
        searchBar.endEditing(true)
    }
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        print("Scroll view drag")

        searchBar.endEditing(true)
    }
}
