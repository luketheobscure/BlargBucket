//
//  BlargAppearance.swift
//  BlargBucket
//
//  Created by Luke Deniston on 8/16/14.
//  Copyright (c) 2014 Luke Deniston. All rights reserved.
//

import Foundation
import UIKit

class BlargAppearance {
	class func apply() {
		UINavigationBar.appearance().barTintColor = UIColor.seafoam()
		UINavigationBar.appearance().titleTextAttributes = [
			NSForegroundColorAttributeName: UIColor.whiteColor(),
			NSFontAttributeName: UIFont(name: "Avenir Next Medium", size: 20)!
		]
		UINavigationBar.appearance().tintColor = UIColor.sharkFinGray()
		UIBarButtonItem.appearance().setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Avenir Next Medium", size: 14)!], forState: UIControlState.Normal)

//		UITabBar.appearance().barTintColor = UIColor.seafoam()
		UITabBar.appearance().tintColor = UIColor.seafoam()

//		UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.whiteColor()], forState: UIControlState.Normal)
		UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.seafoam()], forState: UIControlState.Selected)

		//UIButton.appearance().backgroundColor = UIColor.yellowish()
		UIButton.appearance().tintColor = UIColor.seafoam()

		UITextField.appearance().backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.6)
		UITextField.appearance().font = UIFont(name: "Avenir Next", size: 14)


//		UITableViewCell.appearance().backgroundColor = UIColor.sharkFinGray()


		
	}
}
