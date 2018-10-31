//
//  CountryListController.swift
//  agent
//
//  Created by Sushil Shinde on 30/10/18.
//  Copyright © 2018 Sushil Shinde. All rights reserved.
//

import Foundation
import UIKit

class CountryListController: UIViewController, UITableViewDelegate, UITableViewDataSource {
	
	@IBOutlet weak var countryTableView: UITableView!
	
	let worlds = WorldData()
	var countryData : [Country] = [Country]()
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		//assign table view delegate to self
		countryTableView.delegate = self
		countryTableView.dataSource = self
		
		//register custom cell view
		countryTableView.register(UINib(nibName: "ItemViewCell", bundle: nil), forCellReuseIdentifier: "customItemCell")

		getCountryData()
	}
	
	
	//delegate method to assign number of cell count
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return countryData.count
	}
	
	//delegate method to create cell and assign data to tableView cell
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "customItemCell", for: indexPath) as! ItemViewCell
		cell.continentName.text = countryData[indexPath.row].continentName
		cell.countryCode.text = countryData[indexPath.row].countryCode
		cell.countryName.text = countryData[indexPath.row].countryName
		return cell
	}
	
	//get country data from api
	func getCountryData() {
		worlds.getCountries(completionHandler: { (result, error) in
			if(error != nil) {
				print(error)
			} else {
				result?.forEach{
					(key, value) in
					let country = Country()
					country.continentName = value["continent"].string!
					country.countryName = value["country_name"].string!
					country.countryCode = value["code"].string!
					self.countryData.append(country)
				}
				self.updateTableView()
			}
		})
	}
	
	//update table view properties
	func updateTableView() {
		countryTableView.rowHeight = UITableViewAutomaticDimension
		countryTableView.estimatedRowHeight = 120.0
		countryTableView.reloadData()
	}
}
