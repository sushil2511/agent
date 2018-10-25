//
//  ViewController.swift
//  agent
//
//  Created by Sushil Shinde on 17/10/18.
//  Copyright © 2018 Sushil Shinde. All rights reserved.
//

import UIKit
import SVProgressHUD
import SwiftyJSON

class HomeController: UIViewController, UITextFieldDelegate {

	@IBOutlet weak var email: UITextField!
	@IBOutlet weak var password: UITextField!
	@IBOutlet weak var responser: UILabel!
	
	let user = User()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		email.delegate = self
		password.delegate = self
		
		self.checkForSession()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
		
	}

	//onClick login button action
	@IBAction func onLogin(_ sender: UIButton) {
		SVProgressHUD.show()
		let valid = validateFields()
		if valid {
			var result : JSON = []
			user.getAccessToken(email: email.text!, password: password.text!, completionHandler: {
				(response, error) -> () in
				if let token = response!["access_token"].string {
					result = response!
					self.user.saveTokenDetails(result: result)
					SVProgressHUD.dismiss()
					
					self.goToDashboard()
					
				} else if response!["error"].string == "invalid_credentials" {
					self.responser.text = "Invalid Credentials"
					self.responser.textColor = .red
				} else {
					self.responser.text = "Opps, something went wrong! Try again."
					self.responser.textColor = .red
					SVProgressHUD.dismiss()
				}
			})
		}
		SVProgressHUD.dismiss()
	}
	
	//Function to validate login fields
	func validateFields() -> Bool {
		var valid = true
		var message = ""
		if (email.text?.isEmpty)! {
			valid = false;
			message += "Email is required \n"
			email.backgroundColor = .red
		}
		if (password.text?.isEmpty)! {
			valid = false;
			message += "Password is required \n"
			password.backgroundColor = .red
		}
		responser.text = message
		UIView.animate(withDuration: 0.3){
			self.responser.textColor = .red
			self.view.layoutIfNeeded()
		}
		
		
		return valid
	}
	
	//check if text field is started to edit make reset them
	func textFieldDidBeginEditing(_ textField: UITextField) {
		textField.backgroundColor = .white
	}
	
	//Go to user dashboard controller view
	func goToDashboard() {
		let userHomeBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
		guard let userControlVc = userHomeBoard.instantiateViewController(withIdentifier: "UserViewController") as? UserViewController else {
			return
		}
		
		present(userControlVc, animated: true, completion: nil)
	}
	
	func checkForSession() {
		let token = self.user.getExistingToken()
		if !token.isEmpty {
			self.goToDashboard()
		}
	}
}

