//
//  Reviewer.swift
//  BlargBucket
//
//  Created by Luke Deniston on 10/23/14.
//  Copyright (c) 2014 Luke Deniston. All rights reserved.
//

import Foundation
import CoreData

/// Represents a user reviewer on a pull request
public class Reviewer: NSManagedObject {

	/// Has the user approved the PR
    @NSManaged var approved: NSNumber

	/// The relevant PR
    @NSManaged var belongsToPullRequest: BlargBucket.PullRequest

	/// The relevant user
    @NSManaged var belongsToUser: BlargBucket.User

	/**
		Designated initializer. Creates a Reviewer
		
		:param: user A user
		:param: pullRequest A pull request
	*/
	convenience init(user: User, pullRequest: PullRequest){
		let entity = NSEntityDescription.entityForName("Reviewer", inManagedObjectContext: NSManagedObjectContext.defaultContext())
		self.init(entity: entity!, insertIntoManagedObjectContext: NSManagedObjectContext.defaultContext())
		belongsToUser = user
		belongsToPullRequest = pullRequest
	}

}
