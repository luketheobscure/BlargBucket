//
//  LoginViewController.swift
//  BlargBucket
//
//  Created by Luke Deniston on 8/16/14.
//  Copyright (c) 2014 Luke Deniston. All rights reserved.
//

import UIKit
import QuartzCore

/// The main log in view. This is the first view that's presented if you're not logged in.
class LoginViewController: UIViewController {

	///The user name field
	@IBOutlet weak var usernameField: UITextField!

	/// The password field
	@IBOutlet weak var passwordField: UITextField!

	/// The log in button
	@IBOutlet weak var loginButton: UIButton!

	/// Designated initializer
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

	/// Handles the action when the login button is pushed
	@IBAction func loginButtonPushed(sender: AnyObject) {
		let hud = MBProgressHUD.showHUDAddedTo(view, animated: true)
		hud.mode = MBProgressHUDModeCustomView
		hud.customView = UIImageView(image: UIImage.sd_animatedGIFNamed("tetris"))
		let authToken = Locksmith.createAuthToken(usernameField.text, password: passwordField.text)

		DataFetcher.setAuthToken(authToken)
		DataFetcher.loginAsUser() { (success, error) in
			MBProgressHUD.hideHUDForView(self.view, animated: true)
			if (success) {
				AppDelegate.sharedInstance().window?.rootViewController = MainTabBarViewController()
			}
		}

	}
}
