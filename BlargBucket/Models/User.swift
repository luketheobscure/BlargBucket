//
//  User.swift
//  BlargBucket
//
//  Created by Luke Deniston on 8/20/14.
//  Copyright (c) 2014 Luke Deniston. All rights reserved.
//

import UIKit
import CoreData

/// Used in looking up the current user in `standardUserDefaults`
private var currentUserKey = "Current User"

/// A user on bitbucket
public class User: BlargManagedObject {

	@NSManaged public var avatar: NSString?
	@NSManaged public var display_name: NSString?
	@NSManaged public var last_name: NSString?
	@NSManaged public var first_name: NSString?
	@NSManaged public var username: NSString?

	/// Gets the current user based on NSUserDefaults.standardUserDefaults
	public class func currentUser() -> User? {
		let username: String? = NSUserDefaults.standardUserDefaults().valueForKey(currentUserKey) as? String
		return User.findFirstByAttribute("username", withValue: username) as? User
	}

	/// Sets the users username as the current user in the defaults
	public func makeCurrentUser() {
		NSUserDefaults.standardUserDefaults().setValue(self.username, forKeyPath: currentUserKey)
	}

	/**
		Has the user approved the pull request?
		
		:param: pullRequest The pull request in question
	*/
	func hasApprovedPullRequest(pullRequest:PullRequest) -> Bool {
		for reviewer in pullRequest.reviewersArray() {
			if (username == (reviewer as Reviewer).belongsToUser.username){
				return true
			}
		}
		return false

	}

}
