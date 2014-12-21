//
//  Event.swift
//  BlargBucket
//
//  Created by Luke Deniston on 8/19/14.
//  Copyright (c) 2014 Luke Deniston. All rights reserved.
//

import UIKit
import CoreData

/// An event in the BitBucket activity stream
public class Event: BlargManagedObject {

	/// Not a real value returning from Bitbucket. We're faking it
	@NSManaged public var eventID: NSString?
	@NSManaged public var event: NSString?
	@NSManaged public var node: NSString?
	@NSManaged public var utc_created_on: NSDate?

	@NSManaged public var belongsToUser: User?
	@NSManaged public var belongsToRepository: Repository?
	@NSManaged public var hasCommits: NSSet?

	/**
	Deletes all the events for a repo. Bitbucket doesn't give events an ID, so we just blow it away each time we need to fetch it. :(

	:param: repo The repository to get the events for.
	*/
	class func deleteAll(repo: Repository) {
		let events = Event.findByAttribute("belongsToRepository", withValue: repo)
		for event in events {
			event.deleteEntity()
		}
	}

	/// Fakes a primary key for magical record
	func willImport(data:NSDictionary){
		if let createdOn = data["utc_created_on"] as? String {
			self.eventID = createdOn
		}
	}

}
