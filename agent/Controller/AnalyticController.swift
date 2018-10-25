//
//  AnalyticController.swift
//  agent
//
//  Created by Sushil Shinde on 25/10/18.
//  Copyright © 2018 Sushil Shinde. All rights reserved.
//

import Foundation
import UIKit
import Charts

class AnalyticController: UIViewController {
	
	@IBOutlet weak var piechart: PieChartView!
	
	var valueOne = PieChartDataEntry(value: 0)
	var valueTwo = PieChartDataEntry(value: 0)
	var dataEntries = [PieChartDataEntry]()
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
	
		valueOne.value = Double(arc4random_uniform(100))
		valueOne.label = "Item 1"
		valueTwo.value = Double(arc4random_uniform(100))
		valueTwo.label = "Item 2"
		
		dataEntries = [valueOne, valueTwo]
		updateChart()
	}
	
	func updateChart() {
		let chartDataSet = PieChartDataSet(values: dataEntries, label: "Sample")
		let chartData = PieChartData(dataSet: chartDataSet)
		
		let colors = [UIColor(ciColor: .red), UIColor(ciColor: .green)]
		chartDataSet.colors = colors
		piechart.data = chartData

	}
	
}
