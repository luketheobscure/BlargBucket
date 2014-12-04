//
//  AppDelegate.swift
//  BlargBucket
//
//  Created by Luke Deniston on 8/13/14.
//  Copyright (c) 2014 Luke Deniston. All rights reserved.
//

import UIKit
import Security
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
                            
	var window: UIWindow?

	/// The selected repository
	var activeRepo : Repository? {
		didSet {
			if activeRepo!.resource_uri == nil {
				return
			}
			NSUserDefaults.standardUserDefaults().setObject(activeRepo!.resource_uri!, forKey: "activeRepo")
			NSNotificationCenter.defaultCenter().postNotificationName(Notifications().RepoChanged, object: activeRepo)
			DataFetcher.fetchPullRequests(activeRepo!)
		}
	}


	func application(application: UIApplication!, didFinishLaunchingWithOptions launchOptions: NSDictionary!) -> Bool {

		BlargAppearance.apply()

		window = UIWindow(frame: UIScreen.mainScreen().bounds)
		window?.makeKeyAndVisible()

		// TODO: Make a helper class for LockSmith... no more strings
		let (dictionary, error) = Locksmith.loadData(forKey: "password", inService: "BlargService", forUserAccount: "BlargUser")

		if dictionary != nil {
			DataFetcher.setAuthToken(dictionary!["password"] as String)

			let repoURL: String? = NSUserDefaults.standardUserDefaults().objectForKey("activeRepo") as String?

			if repoURL != nil {
				var repo = Repository.repoWithURL(repoURL!)
				activeRepo = repo
			}

			window?.rootViewController = MainTabBarViewController()
		} else {
			window?.rootViewController = LoginViewController()
		}
		
		return true
	}

	class func sharedInstance() -> AppDelegate {
		return UIApplication.sharedApplication().delegate as AppDelegate
	}

	func applicationWillTerminate(application: UIApplication!) {
		CoreDataStack.sharedInstance.saveContext()
	}

}

