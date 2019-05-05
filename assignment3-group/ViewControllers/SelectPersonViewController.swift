//
//  SelectPersonViewController.swift
//  assignment3-group
//
//  Created by hoang on 5/4/19.
//  Copyright © 2019 Hoang, Truong Quoc. All rights reserved.
//

import UIKit
import Firebase

class SelectPersonViewController: UITableViewController {
    enum nameOfArray: Int {
        case canShare, shared
    }
    var info = [[String]]()
    var owner: String?
    var fileName: String?
    let reuseIdentifier = "Cell"

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
            
            self.tableView.reloadData()
        }
        
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
        return info[section].count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)

         //Configure the cell...
        cell.textLabel?.text = info[indexPath.section][indexPath.row]

        return cell
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var res: String?
        if let array = nameOfArray(rawValue: section){
            switch array {
                case .canShare:
                    res = "People you can share"
                case .shared:
                    res = "Shared To"
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
}
