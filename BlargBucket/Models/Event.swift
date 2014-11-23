//
//  Event.swift
//  BlargBucket
//
//  Created by Luke Deniston on 8/19/14.
//  Copyright (c) 2014 Luke Deniston. All rights reserved.
//

import UIKit
import CoreData

class Event: BlargManagedObject {
   @NSManaged var event: NSString?
   @NSManaged var event_description: NSString?
   @NSManaged var node: NSString?
   @NSManaged var utc_created_on: NSDate?

   @NSManaged var belongsToUser: User?
   @NSManaged var belongsToRepository: Repository?
   @NSManaged var hasCommits: NSSet?

	class func newEvent() -> Event {
		return NSEntityDescription.insertNewObjectForEntityForName("Event", inManagedObjectContext: CoreDataStack.sharedInstance.managedObjectContext) as Event
	}

	func setUtc_created_on(date: AnyObject){
		let createdOnKey: String = "utc_created_on"
		checkAndSetDate(date, key: createdOnKey)
	}

}
