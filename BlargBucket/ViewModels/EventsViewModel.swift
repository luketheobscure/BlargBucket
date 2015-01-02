//
//  EventsViewModel.swift
//  BlargBucket
//
//  Created by Luke Deniston on 8/20/14.
//  Copyright (c) 2014 Luke Deniston. All rights reserved.
//

import UIKit
import CoreData

/// Finds events for a repository
class EventsViewModel: NSFetchedResultsController {

	/**
		Designated initializer
		
		:param: repository The repo to find the events for
	*/
	convenience init(repository:Repository){
		let fetchRequest = NSFetchRequest(entityName: "Event")
		fetchRequest.sortDescriptors = [ NSSortDescriptor(key: "utc_created_on", ascending: false) ]
		fetchRequest.predicate = NSPredicate(format: "belongsToRepository = %@", repository)
		fetchRequest.relationshipKeyPathsForPrefetching = ["hasCommits", "belongsToUser", "user"]
		self.init(fetchRequest: fetchRequest, managedObjectContext: NSManagedObjectContext.defaultContext(), sectionNameKeyPath: nil, cacheName: nil)
		DataFetcher.fetchRepoInfo()
	}

	/**
		Finds an event
		
		:param: indexPath Returns the event found here
	*/
	func modelAtIndexPath(indexPath: NSIndexPath) -> Event! {
		return objectAtIndexPath(indexPath) as Event
	}

	/**
		Finds the title for an `Event`
		
		:param: event The event to find the title for
	*/
	func eventTitle(event: Event) -> String {
		var description:String?
		if event.hasCommits?.count != 0 {
			description = "pushed \(event.hasCommits!.count) Commits"
		} else {
			description = NSLocalizedString(event.event!, comment: event.event!)
		}
		return "\(event.belongsToUser!.display_name) \(description!)"
	}

	/**
		Gets the string from and `Event.utc_created_on` date
		
		:param: event The event in question
	*/
	func eventCreated(event: Event) -> String {
		if event.utc_created_on != nil {
			return NSDateFormatter.localizedStringFromDate(event.utc_created_on!, dateStyle: NSDateFormatterStyle.ShortStyle, timeStyle: NSDateFormatterStyle.ShortStyle)
		} else {
			return ""
		}
	}
}
