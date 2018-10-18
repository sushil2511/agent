//
//  LoginViewController.swift
//  agent
//
//  Created by Sushil Shinde on 17/10/18.
//  Copyright © 2018 Sushil Shinde. All rights reserved.
//

import UIKit
import DatePickerDialog


class RegisterViewController: UIViewController, UITextFieldDelegate {

	
	@IBOutlet weak var birthdate: UITextField!
	@IBOutlet weak var fname: UITextField!
	@IBOutlet weak var email: UITextField!
	@IBOutlet weak var password: UITextField!
	@IBOutlet weak var responseBox: UILabel!
	@IBOutlet weak var passwordAgain: UITextField!
	
	
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
		let valid = validateAll()
		if !valid {
			print("error")
		}
	
	}
	
	func validateAll() -> Bool {
		var valid = true
		var message = ""
		if (fname.text?.isEmpty)! {
			valid = false;
			message += "First name is required \n"
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
			print("valid")
		} else {
			print("invalid date")
			message += "Please select date"
			birthdate.backgroundColor = .red
		}
		
		responseBox.text = "\(message)"
	
		return valid
	}
	
}
