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
import SVProgressHUD

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


class AnalyticController: UIViewController, UIScrollViewDelegate, ChartViewDelegate {
	
//	@IBOutlet weak var piechart: PieChartView!
	
	@IBOutlet weak var pager: UIPageControl!
	@IBOutlet weak var scrollView: UIScrollView!
	var dataEntries = [PieChartDataEntry]()
	let wdata = WorldData()
	var frame = CGRect(x: 0, y: 0, width: 0, height: 0)
	let pages = [1, 2, 3]
	

	var pieChart = PieChartView()
	var lineChart = LineChartView()
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.

		createCarosal()
	}

	
	func createCarosal() {
		pager.numberOfPages = pages.count;
		for index in 0..<pages.count {
			frame.origin.x = scrollView.frame.size.width * CGFloat(index)
			frame.size.width = scrollView.frame.size.width
			frame.size.height = scrollView.frame.size.height
			scrollView.backgroundColor = .random()
			print(scrollView.frame.width, scrollView.frame.height)
			switch index {
			case 0:
				pieChart = PieChartView(frame: frame)
				getPieChartData()
				pieChart.backgroundColor = .blue
				print(pieChart.frame.width, pieChart.frame.height)
				
				scrollView.addSubview(pieChart)
				break
			case 1:
				lineChart = LineChartView(frame: frame)
				getLineChartData()
				scrollView.addSubview(lineChart)
				//TODO: line chart
				break
			case 2:
				//todo another chart
				break
			default:
				break
			}

		}
		
		scrollView.contentSize = CGSize(width: (scrollView.frame.size.width * CGFloat(pages.count)), height: scrollView.frame.size.height)
		scrollView.delegate = self
	}
	
	func getPieChartData() {
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
//			chartDataSet.valueLinePart1OffsetPercentage = 0.7;
//			chartDataSet.valueLinePart1Length = 0.4;
//			chartDataSet.valueLinePart2Length = 0.8;
//			chartDataSet.yValuePosition = .outsideSlice
			chartData.setValueTextColor(.black)
			chartDataSet.colors = colors
			self.pieChart.drawCenterTextEnabled = false
			chartData.setDrawValues(false)
			self.pieChart.data = chartData
			self.pieChart.notifyDataSetChanged()
		})
	}
	
	func getLineChartData() {
		var dataPoints = ["Mon", "Tue", "Wed", "The", "Fri", "sat", "sun"]
		var values = [45.2, 151, 120, 26, 78, 120, 99, 124, 62, 49, 55]
		lineChart.delegate = self
		var dataEntries: [ChartDataEntry] = []
		var days: [String] = []
		for i in 0..<dataPoints.count {
			let entry = ChartDataEntry(x: values[i], y: Double(i))
			dataEntries.append(entry)
		}
		let lineChartDataSet = LineChartDataSet(values: dataEntries, label: nil)
		lineChartDataSet.circleColors = [.white]
		let lineChartData = LineChartData(dataSet: lineChartDataSet)
		lineChart.data = lineChartData
		lineChart.notifyDataSetChanged()
	}

	
	
	func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
		let pageNumber = scrollView.contentOffset.x / scrollView.frame.size.width
		print(scrollView.contentOffset.x, scrollView.frame.size.width)
		pager.currentPage = Int(round(pageNumber))
	}

}
