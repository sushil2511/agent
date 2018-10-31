//
//  UserViewController.swift
//  agent
//
//  Created by Sushil Shinde on 17/10/18.
//  Copyright © 2018 Sushil Shinde. All rights reserved.
//

import UIKit
import SVProgressHUD
class UserViewController: UIViewController {

	var user = User()
	
	@IBOutlet weak var agentName: UILabel!
	@IBOutlet weak var agentEmail: UILabel!
	@IBOutlet weak var agentId: UILabel!
	override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.		
		self.checkSessionStatus()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	//on logout button click function
	@IBAction func logout(_ sender: UIButton) {
		user.logout() {
			(response, error) in
			if (error != nil) {
				print(error as Any)
			}
			if (response!["message"].string != nil) {
				KeychainWrapper.standard.removeAllKeys()
				self.goToHome()
			}
		}
	}
	
	//check for session data and fetch user details accordingly
	func checkSessionStatus() {
		let token = self.user.getExistingToken()
		if !token.isEmpty {
			self.user.getUserDetailsFromToken(token: token,  completionHandler: {
				(response, error) -> () in
				if (error != nil) {
					//todo go to login
					print(error as Any)
				}
				if response!["id"].int != nil {
					//Success
					self.agentName.text = "Agent " + response!["name"].string!
					self.agentEmail.text = response!["email"].string!
					self.agentId.text = "00" + String(describing: response!["id"])
					
				} else if response!["error"].string != nil {
					//todo go to login
					print("error in login:", response ?? "login error")
					KeychainWrapper.standard.removeAllKeys()
					self.goToHome()
				} else {
					//todo go to login
				}
			})
		} else {
			//TODO - Go back to login
		}
	}
	
	//Go to home controller view
	func goToHome() {
		let userHomeBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
		guard let userControlVc = userHomeBoard.instantiateViewController(withIdentifier: "HomeController") as? HomeController else {
			return
		}
		present(userControlVc, animated: true, completion: nil)
	}
}
