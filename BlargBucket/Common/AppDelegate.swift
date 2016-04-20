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
import MagicalRecord
import Locksmith

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
            guard let repo = activeRepo,
                let resource_uri = repo.resource_uri else
            {
                return
            }
			NSUserDefaults.standardUserDefaults().setObject(resource_uri, forKey: "activeRepo")
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
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {

		BlargAppearance.apply()
		let storeName = "BlargData.sqlite"
		MagicalRecord.setupCoreDataStackWithAutoMigratingSqliteStoreNamed(storeName)
		print("The database is here: \(NSPersistentStore.urlForStoreName(storeName))")

		window = UIWindow(frame: UIScreen.mainScreen().bounds)
		window?.makeKeyAndVisible()

		if let token = Locksmith.getAuthToken(),
            let repoURL = NSUserDefaults.standardUserDefaults().objectForKey("activeRepo") as? String
        {
            DataFetcher.setAuthToken(token)
            activeRepo = Repository.repoWithURL(repoURL)
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
		return UIApplication.sharedApplication().delegate as! AppDelegate
	}

	/// Cleans up the CoreData store
	func applicationWillTerminate(application: UIApplication) {
		MagicalRecord.cleanUp()
	}

}
