//
//  StatisticsViewController.swift
//  assignment3-group
//
//  Created by Pham Trung Hieu on 5/12/19.
//  Copyright © 2019 Hoang, Truong Quoc. All rights reserved.
//

import UIKit
import Charts
import Firebase

extension UIColor{
    convenience init (red: Int, green: Int, blue: Int){
        let newRed = CGFloat(red)/255
        let newGreen = CGFloat(green)/255
        let newBlue = CGFloat(blue)/255
        self.init(red: newRed, green: newGreen, blue:newBlue, alpha: 1.0)
    }
}
// Memory is in MB
var memoryPhoto : Double = 0
var memoryVideo : Double = 0
var memoryAllowed : Double = 50 * 1024 * 1024
var memoryUsed : Double = memoryPhoto + memoryVideo
var memoryLeft : Double = memoryAllowed - memoryUsed


class StatisticsViewController: UIViewController {
    
    
    @IBOutlet weak var totalMemoryPieChart: PieChartView!
    
    @IBOutlet weak var separateMemoryPieChart: PieChartView!
    
    @IBOutlet weak var memoryPercentage: UILabel!
    
    var photoDataEntry = PieChartDataEntry (value: memoryPhoto)
    var videoDataEntry = PieChartDataEntry(value: memoryVideo)
    var memoryUsedDataEntry = PieChartDataEntry(value: memoryUsed)
    var memoryLeftDataEntry = PieChartDataEntry(value: memoryLeft)
    
    var totalMemoryDataEntries = [PieChartDataEntry]()
    
    var separateMemoryDataEntries = [PieChartDataEntry]()
    
    
    func loadTotalFileUsed(){
        
            ref.child("userPicture/\(currentUser!)/fileOwned").observeSingleEvent(of: .value){ snapshot in
            for i in snapshot.children {
                if let i2 = (i as? DataSnapshot)?.value as? String {
                    let workingFile = (i2.contains("thumbnail")) ? (i2.replacingOccurrences(of: "thumbnail", with: "") + ".mp4") : i2
                    storageRef.child(workingFile).getMetadata{ metadata, error in
                        if error != nil {
                            print("file name \(workingFile) get metadata error \(error?.localizedDescription)")
                        }
                        else {
                            print("file name \(workingFile) has the size of \(metadata?.size)")
                        }
                    }
                }
                else {
                    print("Invalid path")
                }
            }
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        guard let color = UserDefaults.standard.object(forKey: "bgColor") as? String else {
            return
        }
        if color == "yellow" {
            self.view.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
        }
        
        totalMemoryPieChart.animate(xAxisDuration: 1, yAxisDuration: 1)
        separateMemoryPieChart.animate(xAxisDuration: 1, yAxisDuration: 1)
        
        photoDataEntry.label = ""
        videoDataEntry.label = ""
        memoryUsedDataEntry.label = ""
        memoryLeftDataEntry.label = ""

        totalMemoryPieChart.usePercentValuesEnabled = true
        separateMemoryPieChart.usePercentValuesEnabled = true
        
        totalMemoryPieChart.holeRadiusPercent = 0.80
        separateMemoryPieChart.holeRadiusPercent = 0.80
        
        totalMemoryPieChart.legend.enabled = false
        
        separateMemoryPieChart.legend.enabled = false
        
        separateMemoryPieChart.centerText = ""
        
        totalMemoryPieChart.drawEntryLabelsEnabled = false
       
//       totalMemoryPieChart.entryLabelColor = .black
        
        separateMemoryPieChart.drawEntryLabelsEnabled = false
        
//        separateMemoryPieChart.entryLabelColor = .black
        
        
        totalMemoryDataEntries = [memoryUsedDataEntry, memoryLeftDataEntry]
        separateMemoryDataEntries = [photoDataEntry, videoDataEntry, memoryLeftDataEntry]
        
        memoryPercentage.text = "\(String(format: "%0.f", (memoryUsed/memoryAllowed)*100))%"
        
        updateTotalChart()
        updateSeparateChart()
    }
    
    func updateTotalChart(){
        let totalDataSet = PieChartDataSet(entries: totalMemoryDataEntries, label: nil)

        let totalColors = [UIColor(red: 233, green: 60, blue: 104), UIColor(red: 232, green: 204,blue: 211)]
        totalDataSet.colors = totalColors
        
        totalDataSet.entryLabelColor = .black
        totalDataSet.drawValuesEnabled = false
        
        
        totalMemoryPieChart.data =  PieChartData(dataSet: totalDataSet)

    }
    
    func updateSeparateChart(){
        let separateDataSet = PieChartDataSet(entries: separateMemoryDataEntries, label: nil)
        
        let separateColors = [UIColor(red: 178, green: 0, blue: 255),UIColor(red: 0, green: 38, blue: 255), UIColor(red: 255, green: 255,blue: 255)]
        
        separateDataSet.colors = separateColors
        
        separateDataSet.entryLabelColor = .black
        separateDataSet.drawValuesEnabled = false
        
        separateMemoryPieChart.data = PieChartData(dataSet: separateDataSet)
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
