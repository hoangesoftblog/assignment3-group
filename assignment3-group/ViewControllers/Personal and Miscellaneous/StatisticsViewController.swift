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

var memoryPhoto : Double = 23
var memoryVideo : Double = 4
var memoryAllowed : Double = 100
var memoryUsed : Double = memoryPhoto + memoryVideo
var memoryLeft : Double = memoryAllowed - memoryUsed


class StatisticsViewController: UIViewController {
    
    
    @IBOutlet weak var totalMemoryPieChart: PieChartView!
    
    @IBOutlet weak var separateMemoryPieChart: PieChartView!
    
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

        totalMemoryPieChart.usePercentValuesEnabled = true
        separateMemoryPieChart.usePercentValuesEnabled = true
        
        totalMemoryPieChart.holeRadiusPercent = 0.90
        separateMemoryPieChart.holeRadiusPercent = 0.90
        
        totalMemoryPieChart.legend.enabled = false
        
        separateMemoryPieChart.legend.enabled = false
        
        separateMemoryPieChart.centerText = ""
        
        totalMemoryPieChart.drawEntryLabelsEnabled = false
       
       totalMemoryPieChart.entryLabelColor = .black
        separateMemoryPieChart.drawEntryLabelsEnabled = false
        
        separateMemoryPieChart.entryLabelColor = .black
        
        
        totalMemoryDataEntries = [memoryUsedDataEntry, memoryLeftDataEntry]
        separateMemoryDataEntries = [photoDataEntry, videoDataEntry, memoryLeftDataEntry]
        
        updateTotalChart()
        updateSeparateChart()
    }
    
    func updateTotalChart(){
        let totalDataSet = PieChartDataSet(entries: totalMemoryDataEntries, label: nil)

        let totalColors = [UIColor(red: 0, green: 212, blue: 130), UIColor(red: 211, green: 248,blue: 220)]
        totalDataSet.colors = totalColors
        
        
        totalMemoryPieChart.data =  PieChartData(dataSet: totalDataSet)

    }
    
    func updateSeparateChart(){
        let separateDataSet = PieChartDataSet(entries: separateMemoryDataEntries, label: nil)
        
        let separateColors = [UIColor(red: 255, green: 43, blue: 108),UIColor(red: 255, green: 108, blue: 43), UIColor(red: 254, green: 215,blue: 223)]
        
        separateDataSet.colors = separateColors
        
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
