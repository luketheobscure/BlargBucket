//
//  User.swift
//  BlargBucket
//
//  Created by Luke Deniston on 8/20/14.
//  Copyright (c) 2014 Luke Deniston. All rights reserved.
//

import UIKit
import CoreData

/// A user on bitbucket
public class User: BlargManagedObject {

	@NSManaged public var avatar: NSString?
	@NSManaged public var display_name: NSString?
	@NSManaged public var last_name: NSString?
	@NSManaged public var first_name: NSString?
	@NSManaged public var username: NSString?

	/// Gets the current user based on NSUserDefaults.standardUserDefaults
	class func currentUser() -> User? {
		// TODO: Make sure there's a user first
		let username: String = NSUserDefaults.standardUserDefaults().valueForKey("Current User") as String
		let request = NSFetchRequest()
		request.entity = NSEntityDescription.entityForName("User", inManagedObjectContext: NSManagedObjectContext.defaultContext())
		request.predicate = NSPredicate(format: "username = '\(username)'")
		var error = NSErrorPointer()
		let results = NSManagedObjectContext.defaultContext().executeFetchRequest(request, error: nil) as Array?
		if error != nil {
			println("Error getting current user: \(error)")
		}
		return results?.last as? User
	}

	/// Gives the first and last name, or the username if those aren't available
	public func fullName() -> NSString {
		var firstName: NSString? = first_name
		let lastName: NSString = last_name ?? ""
		if firstName == nil {
			firstName = username
		}
		
		if firstName == nil {
			return NSLocalizedString("Anonymous", comment: "Anonymous")
		}

		return "\(firstName!) \(lastName)"
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

	/// Workaround for a MagicalRecord bug
	class func MR_entityName() -> String{
		return "User"
	}

}
