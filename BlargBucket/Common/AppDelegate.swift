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

/**
	BlargBucket's AppDelegate. Sets up all the things.
*/
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    /// Main window
	var window: UIWindow?

	/// The currently selected repository
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

	/**
		Post launch setup.
			- Applies appearance
			- Sets up CoreData stack
			- Checks if you're logged in and redirects you accordingly
	*/
	func application(application: UIApplication!, didFinishLaunchingWithOptions launchOptions: NSDictionary!) -> Bool {

		BlargAppearance.apply()
		let storeName = "BlargData.sqlite"
		MagicalRecord.setupCoreDataStackWithAutoMigratingSqliteStoreNamed(storeName)
		println("The database is here: \(NSPersistentStore.urlForStoreName(storeName))")

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

	/**
		Convenience method so you don't have to cast
		
		@return The shared application delegate
	*/
	class func sharedInstance() -> AppDelegate {
		return UIApplication.sharedApplication().delegate as AppDelegate
	}

	/// Cleans up the CoreData store
	func applicationWillTerminate(application: UIApplication!) {
		MagicalRecord.cleanUp()
	}

}

