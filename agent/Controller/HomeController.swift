//
//  ViewController.swift
//  agent
//
//  Created by Sushil Shinde on 17/10/18.
//  Copyright © 2018 Sushil Shinde. All rights reserved.
//

import UIKit
import SVProgressHUD

class HomeController: UIViewController, UITextFieldDelegate {

	@IBOutlet weak var email: UITextField!
	@IBOutlet weak var password: UITextField!
	@IBOutlet weak var responser: UILabel!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		email.delegate = self
		password.delegate = self
		// Do any additional setup after loading the view, typically from a nib.
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
		
	}

	@IBAction func onLogin(_ sender: UIButton) {
		SVProgressHUD.show()
		let valid = validateFields()
		if valid {
			performSegue(withIdentifier: "goToDashboard", sender: self)
			SVProgressHUD.dismiss()
		}
		
	}
	
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
	
	func textFieldDidBeginEditing(_ textField: UITextField) {
		textField.backgroundColor = .white
	}
}

