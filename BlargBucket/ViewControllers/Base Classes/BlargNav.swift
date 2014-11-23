//
//  BlargNav.swift
//  BlargBucket
//
//  Created by Luke Deniston on 8/17/14.
//  Copyright (c) 2014 Luke Deniston. All rights reserved.
//

import UIKit
import QuartzCore

/**
	UINavigationController that has "repos" button on the right
*/
class BlargNav: UINavigationController {

	let repoImage : UIImageView?

	override init(rootViewController: UIViewController) {
		super.init(rootViewController: rootViewController)
		navigationBar.translucent = false

		var logoURL = AppDelegate.sharedInstance().activeRepo?.logo ?? ""
		var repoImage = UIImageView(frame: CGRectMake(0, 0, 30, 30))
		repoImage.sd_setImageWithURL(NSURL(string: logoURL), placeholderImage: UIImage(named: "repoPlaceholder"))
		repoImage.layer.cornerRadius = 15
		repoImage.layer.borderColor = UIColor.yellowish().CGColor
		repoImage.layer.borderWidth = 2
		repoImage.layer.masksToBounds = true

		repoImage.addGestureRecognizer( UITapGestureRecognizer(target: self, action: "showRepoPicker") )

		var repoButton = UIBarButtonItem(customView: repoImage)

		rootViewController.navigationItem.rightBarButtonItem = repoButton

		NSNotificationCenter.defaultCenter().addObserverForName(Notifications().RepoChanged, object: nil, queue: nil) { (_) -> Void in
			var logoURL = AppDelegate.sharedInstance().activeRepo?.logo ?? ""
			repoImage.sd_setImageWithURL(NSURL(string: logoURL), placeholderImage: UIImage(named: "repoPlaceholder"))
		}



	}

	required init(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}

	override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
	}

	/// Presents a RepositoriesTableViewController modally
	func showRepoPicker() {
		var repositoriesVC = RepositoriesTableViewController()
		repositoriesVC.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Close", style: UIBarButtonItemStyle.Plain, target: self, action: "closeModal" )
		var navVC = UINavigationController(rootViewController: repositoriesVC)
		self.presentViewController(navVC, animated: true, completion: nil)
	}

	/// Dismisses the modal view controller
	func closeModal(){
		self.dismissViewControllerAnimated(true, completion: nil)
	}

}
