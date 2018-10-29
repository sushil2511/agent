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
import SVProgressHUD
class RegisterViewController: UIViewController, UITextFieldDelegate {

	
	@IBOutlet weak var birthdate: UITextField!
	@IBOutlet weak var fname: UITextField!
	@IBOutlet weak var email: UITextField!
	@IBOutlet weak var password: UITextField!
	@IBOutlet weak var responseBox: UILabel!
	@IBOutlet weak var passwordAgain: UITextField!
	
	let registerUrl = "http://agenthub.test/api/auth/register"
	let user = User()
	
	
	override func viewDidLoad() {
        super.viewDidLoad()
		birthdate.delegate = self
		fname.delegate = self
		email.delegate = self
		passwordAgain.delegate = self
		password.delegate = self
		responseBox.text = ""
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
		SVProgressHUD.show()
		if valid {
			let formData : [String: String] = [
				"name" : fname.text!,
				"email" : email.text!,
				"birth_date" : birthdate.text!,
				"password" : password.text!,
				"password_confirmation" : passwordAgain.text!
			];
			
			let headers: HTTPHeaders = [
				"Accept": "application/json"
			]
			
			//Post request to server to create user
			Alamofire.request(registerUrl, method: .post,  parameters: formData, encoding: JSONEncoding.default, headers: headers)
				.responseJSON { response  in
					if response.result.isSuccess {
						print(response)
						let result = JSON(response.result.value!)
						switch response.response?.statusCode {
						case 422?:
							//form validation failed
							var errors : String = ""
							if let emailError = result["email"][0].string {
								errors += "\(emailError) \n"
							}
							if let nameError = result["name"][0].string {
								errors += "\(nameError) \n"
							}
							if let passwordError = result["password"][0].string {
								errors += "\(passwordError) \n"
							}
							if let birthError = result["birth_date"][0].string {
								errors += "\(birthError) \n"
							}
							self.responseBox.text = errors
							self.responseBox.textColor = .red
							break
							
						case 201?:
							//Successsfully created user
							self.responseBox.text = result["message"].string
							self.responseBox.textColor = .black
							
							//get access token for a user
							self.user.getAccessToken(email : formData["email"]!, password: formData["password"]!, completionHandler:  {
								(response, error) -> () in
								if let token = response!["access_token"].string {
									let result = response!
									self.user.saveTokenDetails(result: result)
									SVProgressHUD.dismiss()
									
									self.goToDashboard()
									
								} else if response!["error"].string == "invalid_credentials" {
									self.responseBox.text = "Invalid Credentials"
									self.responseBox.textColor = .red
								} else {
									self.responseBox.text = "Opps, something went wrong! Try again."
									self.responseBox.textColor = .red
									SVProgressHUD.dismiss()
								}
							})
							break
						default:
							return
						}
					} else {
						print(response.result, response.result.isFailure)
						SVProgressHUD.dismiss()
					}
			}
			self.responseBox.setNeedsLayout()
			self.responseBox.layoutIfNeeded()
			SVProgressHUD.dismiss()
		}
		SVProgressHUD.dismiss()
	}
	
	//validate register form
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
	
	//Go to user dashboard controller view
	func goToDashboard() {
		let userHomeBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
		guard let userControlVc = userHomeBoard.instantiateViewController(withIdentifier: "UserViewController") as? UserViewController else {
			return
		}
		
		present(userControlVc, animated: true, completion: nil)
	}
	

	//textfield delegate to disable keyboard on birthday click
	func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
		if textField == birthdate {
			return false
		}
		return true
	}
}
