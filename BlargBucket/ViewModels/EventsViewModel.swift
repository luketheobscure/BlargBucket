//
//  EventsViewModel.swift
//  BlargBucket
//
//  Created by Luke Deniston on 8/20/14.
//  Copyright (c) 2014 Luke Deniston. All rights reserved.
//

import UIKit
import CoreData

class EventsViewModel: NSFetchedResultsController {

	convenience init(repository:Repository){
		let fetchRequest = NSFetchRequest(entityName: "Event")
		fetchRequest.sortDescriptors = [ NSSortDescriptor(key: "utc_created_on", ascending: true) ]
		fetchRequest.predicate = NSPredicate(format: "belongsToRepository = %@", repository)
		fetchRequest.relationshipKeyPathsForPrefetching = ["hasCommits", "belongsToUser", "user"]
		self.init(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.sharedInstance.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
		DataFetcher.fetchRepoInfo()
	}

	func modelAtIndexPath(indexPath: NSIndexPath) -> Event! {
		return objectAtIndexPath(indexPath) as Event
	}

	func eventTitle(event: Event) -> String {
		var description:String?
		if event.hasCommits?.count != 0 {
			description = "pushed \(event.hasCommits!.count) Commits"
		} else {
			description = NSLocalizedString(event.event!, comment: event.event!)
		}
		return "\(event.belongsToUser!.fullName()) \(description!)"
	}

	func eventCreated(event: Event) -> String {
		if event.utc_created_on != nil {
			return NSDateFormatter.localizedStringFromDate(event.utc_created_on!, dateStyle: NSDateFormatterStyle.ShortStyle, timeStyle: NSDateFormatterStyle.ShortStyle)
		} else {
			return ""
		}
	}
}
