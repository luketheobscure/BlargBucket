//
//  User.swift
//  BlargBucket
//
//  Created by Luke Deniston on 8/20/14.
//  Copyright (c) 2014 Luke Deniston. All rights reserved.
//

import UIKit
import CoreData

class User: NSManagedObject {

	@NSManaged var avatar: NSString?
	@NSManaged var display_name: NSString?
	@NSManaged var last_name: NSString?
	@NSManaged var first_name: NSString?
	@NSManaged var username: NSString?

	class func userWithUsername(username:AnyObject) -> User {
		var user : User?
		let request = NSFetchRequest()
		request.entity = NSEntityDescription.entityForName("User", inManagedObjectContext: CoreDataStack.sharedInstance.managedObjectContext)
		request.predicate = NSPredicate(format: "username = '\(username)'")
		var error = NSErrorPointer()
		let results = CoreDataStack.sharedInstance.managedObjectContext.executeFetchRequest(request, error: nil) as Array?
		user = results?.last as? User

		if user == nil {
			user =  NSEntityDescription.insertNewObjectForEntityForName("User", inManagedObjectContext: CoreDataStack.sharedInstance.managedObjectContext) as? User
			user!.username = username as? NSString
		}

		return user!
	}

	class func currentUser() -> User? {
		// TODO: Make sure there's a user first
		let username: String = NSUserDefaults.standardUserDefaults().valueForKey("Current User") as String
		let request = NSFetchRequest()
		request.entity = NSEntityDescription.entityForName("User", inManagedObjectContext: CoreDataStack.sharedInstance.managedObjectContext)
		request.predicate = NSPredicate(format: "username = '\(username)'")
		var error = NSErrorPointer()
		let results = CoreDataStack.sharedInstance.managedObjectContext.executeFetchRequest(request, error: nil) as Array?
		if error != nil {
			println("Error getting current user: \(error)")
		}
		return results?.last as? User
	}

	func fullName() -> NSString {
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

	func hasApprovedPullRequest(pullRequest:PullRequest) -> Bool {
		// TODO: Implement this.
//		let request = NSFetchRequest()
//		request.entity = NSEntityDescription.entityForName("Reviewer", inManagedObjectContext: CoreDataStack.sharedInstance.managedObjectContext)
//		request.predicate = NSPredicate(format: "belongsToPullRequest = %@ AND belongsToUser = %@", pullRequest, self)
//		request.sortDescriptors = [NSSortDescriptor(key: "approved", ascending: true)]
//		var error = NSErrorPointer()
//		let results = CoreDataStack.sharedInstance.managedObjectContext.executeFetchRequest(request, error: error)
//		if error != nil {
//			println("Error getting current user: \(error)")
//		}
//		let review = results?.last as? Reviewer
//		return	review?.approved as Bool
		return true

	}

}
