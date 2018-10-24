//
//  User.swift
//  agent
//
//  Created by Sushil Shinde on 24/10/18.
//  Copyright © 2018 Sushil Shinde. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class User {
	
	let grantType : String = "password"
	let baseSiteUrl : String = "http://agenthub.test/"
	let clientId : Int = 2
	let clientSecret : String = "yoLPmjF7TJ8gTliGuzFJWpksjT5QNpdm8pZwuXz7"
	
	
	//function to get access token by authorizing user details - email, password
	func getAccessToken(email : String, password : String, completionHandler: @escaping (JSON?, Error?) -> ()) {
		let params = [
			"grant_type" : grantType, "client_id" : clientId, "client_secret" : clientSecret, "username" : email, "password" : password
			] as [String : Any]
		let autheticationUrl : String = "\(baseSiteUrl)oauth/token"
		
		Alamofire.request(autheticationUrl, method: .post,  parameters: params, encoding: JSONEncoding.default, headers: nil)
			.responseJSON { response  in
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
	
	//function to store acees token details into user default
	func saveTokenDetails(result : JSON) {
		result.forEach { (key : String, value : Any) in
			UserDefaults.standard.set(String(describing: value), forKey: key)
		}
	}
	
	//get stored token
	func getExistingToken() -> String {
		return (UserDefaults.standard.string(forKey: "access_token") ?? "")!
	}
	
	//Get user details from token
	func getUserDetailsFromToken(token : String, completionHandler: @escaping (JSON?, Error?) -> ()) {
		let userApiUrl = "\(baseSiteUrl)api/auth/user"
		let tokenType = UserDefaults.standard.string(forKey: "token_type") ?? ""
		let headers = [
			"Accept": "application/json",
			"Authorization" : "\(tokenType) \(token)"
		]
		Alamofire.request(userApiUrl, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers)
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
