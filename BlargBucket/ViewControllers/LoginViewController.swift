//
//  LoginViewController.swift
//  BlargBucket
//
//  Created by Luke Deniston on 8/16/14.
//  Copyright (c) 2014 Luke Deniston. All rights reserved.
//

import UIKit
import QuartzCore

class LoginViewController: UIViewController {
	@IBOutlet weak var usernameField: UITextField!
	@IBOutlet weak var passwordField: UITextField!
	@IBOutlet weak var loginButton: UIButton!

	override init() {
		super.init(nibName: "LoginView", bundle: nil)
	}

	required init(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()

		let gradient = CAGradientLayer()
		gradient.frame = view.bounds
		gradient.colors = NSArray(objects: UIColor.sharkFinGray().CGColor, UIColor.seafoam().CGColor)
		gradient.opacity = 0.8
		view.layer.insertSublayer(gradient, atIndex: 0)

		let backgroundImage = UIImageView(image: UIImage(named: "backgroundImage") )
		view.insertSubview(backgroundImage, atIndex: 0)
    }

	override func viewDidAppear(animated: Bool) {
		loginButton.backgroundColor = UIColor.orangeCream()
		loginButton.layer.cornerRadius = 5
		//loginButton.createShadow(UIColor.sharkFinGray(), radius: 5)
	}
    
	@IBAction func loginButtonPushed(sender: AnyObject) {
		var hash : NSString = "\(usernameField.text):\(passwordField.text)" as NSString
		let data = hash.dataUsingEncoding(NSUTF8StringEncoding)
		let base64Hash = data!.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)

		Locksmith.saveData(["password": base64Hash], forKey: "password", inService: "BlargService", forUserAccount: "BlargUser")

		//TODO: Check auth first
		DataFetcher.setAuthToken(base64Hash)
		DataFetcher.loginAsUser()
		AppDelegate.sharedInstance().window?.rootViewController = MainTabBarViewController()
	}
}
