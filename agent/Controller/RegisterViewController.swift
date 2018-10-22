//
//  LoginViewController.swift
//  agent
//
//  Created by Sushil Shinde on 17/10/18.
//  Copyright © 2018 Sushil Shinde. All rights reserved.
//

import UIKit
import DatePickerDialog
import Alamofire
import SwiftyJSON

class RegisterViewController: UIViewController, UITextFieldDelegate {

	
	@IBOutlet weak var birthdate: UITextField!
	@IBOutlet weak var fname: UITextField!
	@IBOutlet weak var email: UITextField!
	@IBOutlet weak var password: UITextField!
	@IBOutlet weak var responseBox: UILabel!
	@IBOutlet weak var passwordAgain: UITextField!
	
	let registerUrl = "http://agenthub.test/api/auth/register"
	
	
	override func viewDidLoad() {
        super.viewDidLoad()
		birthdate.delegate = self
		fname.delegate = self
		email.delegate = self
		passwordAgain.delegate = self
		password.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	@IBAction func onDateTapped(_ sender: Any) {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd"
		DatePickerDialog().show("Birth Date", doneButtonTitle: "Select", cancelButtonTitle: "Cancel", datePickerMode: .date) {
			(date) -> Void in
			if let dt = date {
				let formatter = DateFormatter()
				formatter.dateFormat = "MM/dd/yyyy"
				self.birthdate.text = formatter.string(from: dt)
			}
		}
	}
	
	@IBAction func onRegister(_ sender: Any) {
		let valid = true//validateAll()
		if true || valid {
			let formData : [String: AnyObject] = [
				"name" : fname.text as AnyObject,
				"email" : email.text as AnyObject,
				"password" : password.text as AnyObject,
				"password_confirmation" : passwordAgain.text as AnyObject
			];
			
			let headers: HTTPHeaders = [
				"Accept": "application/json"
			]
			
			//Post request to server to create user
			Alamofire.request(registerUrl, method: .post,  parameters: formData, encoding: JSONEncoding.default, headers: headers)
				.responseJSON { response  in
					if response.result.isSuccess {
						let result = JSON(response.result.value!)
						//form validation failed
						if response.response?.statusCode == 422 {
							var errors : String = ""
							if let emailError = result["email"][0].string {
								errors += "\(emailError)\n"
							}
							if let nameError = result["name"][0].string {
								errors += "\(nameError)\n"
							}
							if let passwordError = result["password"][0].string {
								errors += "\(passwordError)\n"
							}
							self.responseBox.text = errors
							self.responseBox.textColor = .red
						}else if response.response?.statusCode == 201 {		//Successsfully created user
							self.responseBox.text = result["message"].string
							self.responseBox.textColor = .black
						}
					} else {
						print(response.result, response.result.isFailure)
					}
			}
		}
	
	}
	
	func validateAll() -> Bool {
		var valid = true
		var message = ""
		if (fname.text?.isEmpty)! {
			valid = false;
			message += "Name is required \n"
			fname.backgroundColor = .red
		}
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
		if (passwordAgain.text?.isEmpty)! {
			valid = false;
			message += "Password again is required \n"
			passwordAgain.backgroundColor = .red
		}
		
		if (password.text != passwordAgain.text ) {
			valid = false;
			message += "Password not matched\n"
		}
		
		let dateFormatterGet = DateFormatter()
		dateFormatterGet.dateFormat = "MM/dd/yyyy"
		
		if dateFormatterGet.date(from: birthdate.text!) != nil {
		} else {
			print("invalid date")
			message += "Please select date"
			birthdate.backgroundColor = .red
		}
		
		responseBox.text = "\(message)"
	
		return valid
	}
	
}
