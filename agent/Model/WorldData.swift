//
//  WorldData.swift
//  agent
//
//  Created by Sushil Shinde on 29/10/18.
//  Copyright © 2018 Sushil Shinde. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import Charts

class WorldData: MainModel {
	
	func getPopulation(completionHandler: @escaping (JSON?, Error?) -> ()) {
		//let authKeys = ["access_token", "token_type", "expires_in", "refresh_token"]
		let apiUrl = "\(baseSiteUrl)api/auth/population"
		let token = KeychainWrapper.standard.string(forKey: "access_token") ?? ""
		let tokenType = KeychainWrapper.standard.string(forKey: "token_type") ?? ""
		let headers = [
			"Accept": "application/json",
			"Authorization" : "\(tokenType) \(token)"
		]
		Alamofire.request(apiUrl, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers)
			.responseJSON { response in
				switch response.result {
				case .success(let data) :
					let result = JSON(data)
					completionHandler(result, nil)
					break
				case .failure(let error) :
					completionHandler(nil, error)
					break
				}
		}
	}
	
}
