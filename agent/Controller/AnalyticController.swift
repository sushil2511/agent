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

//extension for random color generate
//calculate color value
extension CGFloat {
	static func random() -> CGFloat {
		return CGFloat(arc4random()) / CGFloat(UInt32.max)
	}
}

//add random value to RGB color object
extension UIColor {
	static func random() -> UIColor {
		return UIColor(red:   .random(),
					   green: .random(),
					   blue:  .random(),
					   alpha: 1.0)
	}
}


class AnalyticController: UIViewController {
	
	@IBOutlet weak var piechart: PieChartView!
	
	var dataEntries = [PieChartDataEntry]()
	let wdata = WorldData()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.

		updateChart()
	}
	
	//Fuction tu update chart values
	func updateChart() {
		var colors : [UIColor] = []
		wdata.getPopulation(completionHandler: {
			(response, error) -> () in
			if (error != nil) {
				print(error)
			}
			response?.forEach{
				(key, value) in
				let element = PieChartDataEntry(value: Double(value["population"].int!))
				element.label = value["country_name"].string!
				self.dataEntries.append(element)
				colors.append(.random())
			}
			
			let chartDataSet = PieChartDataSet(values: self.dataEntries, label: nil)
			let chartData = PieChartData(dataSet: chartDataSet)
			
			chartDataSet.colors = colors
			self.piechart.data = chartData
			
		})
		


	}

}
