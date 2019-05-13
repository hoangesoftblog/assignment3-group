//
//  StatisticsViewController.swift
//  assignment3-group
//
//  Created by Pham Trung Hieu on 5/12/19.
//  Copyright © 2019 Hoang, Truong Quoc. All rights reserved.
//

import UIKit
import Charts

extension UIColor{
    convenience init (red: Int, green: Int, blue: Int){
        let newRed = CGFloat(red)/255
        let newGreen = CGFloat(green)/255
        let newBlue = CGFloat(blue)/255
        self.init(red: newRed, green: newGreen, blue:newBlue, alpha: 1.0)
    }
}
// Memory is in MB
var memoryPhoto : Double = 23
var memoryVideo : Double = 4
var memoryAllowed : Double = 100
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
    
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
       
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
