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

		if KeychainService.loadToken() != nil {
			DataFetcher.setAuthToken(KeychainService.loadToken()!)

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

	func applicationWillResignActive(application: UIApplication!) {
		// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
		// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
	}

	func applicationDidEnterBackground(application: UIApplication!) {
		// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
		// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	}

	func applicationWillEnterForeground(application: UIApplication!) {
		// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
	}

	func applicationDidBecomeActive(application: UIApplication!) {
		// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	}

	func applicationWillTerminate(application: UIApplication!) {
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
		// Saves changes in the application's managed object context before the application terminates.
		CoreDataStack.sharedInstance.saveContext()
	}

}

