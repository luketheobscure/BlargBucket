//
//  PullRequestsViewModel.swift
//  BlargBucket
//
//  Created by Luke Deniston on 8/29/14.
//  Copyright (c) 2014 Luke Deniston. All rights reserved.
//

import UIKit
import CoreData

class PullRequestsViewModel: NSFetchedResultsController {

	convenience init(repository:Repository){
		let fetchRequest = NSFetchRequest(entityName: "PullRequest")
		fetchRequest.sortDescriptors = [ NSSortDescriptor(key: "title", ascending: true) ]
		fetchRequest.predicate = NSPredicate(format: "belongsToRepository = %@", repository)
		fetchRequest.relationshipKeyPathsForPrefetching = ["hasCommits", "belongsToUser", "user"]
		self.init(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.sharedInstance.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
	}

	func modelAtIndexPath(indexPath: NSIndexPath) -> PullRequest! {
		return objectAtIndexPath(indexPath) as PullRequest
	}
   
}
