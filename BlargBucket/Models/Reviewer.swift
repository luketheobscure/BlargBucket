//
//  Reviewer.swift
//  BlargBucket
//
//  Created by Luke Deniston on 10/23/14.
//  Copyright (c) 2014 Luke Deniston. All rights reserved.
//

import Foundation
import CoreData

class Reviewer: NSManagedObject {

    @NSManaged var approved: NSNumber
    @NSManaged var belongsToPullRequest: BlargBucket.PullRequest
    @NSManaged var belongsToUser: BlargBucket.User

	convenience init(user: User, pullRequest: PullRequest){
		let entity = NSEntityDescription.entityForName("Reviewer", inManagedObjectContext: CoreDataStack.sharedInstance.managedObjectContext)
		self.init(entity: entity!, insertIntoManagedObjectContext: CoreDataStack.sharedInstance.managedObjectContext)
		belongsToUser = user
		belongsToPullRequest = pullRequest
	}

}
