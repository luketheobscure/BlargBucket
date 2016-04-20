//
//  PullRequestsViewModel.swift
//  BlargBucket
//
//  Created by Luke Deniston on 8/29/14.
//  Copyright (c) 2014 Luke Deniston. All rights reserved.
//

import UIKit
import CoreData

/// Finds all the pull requests in a repository
class PullRequestsViewModel: NSFetchedResultsController {

	/**
		Designated initializer
		
		- parameter repository: The repository to find the pull requests for
	*/
	convenience init(repository:Repository){
		let fetchRequest = NSFetchRequest(entityName: "PullRequest")
		fetchRequest.sortDescriptors = [ NSSortDescriptor(key: "title", ascending: true) ]
		fetchRequest.predicate = NSPredicate(format: "belongsToRepository = %@", repository)
		fetchRequest.relationshipKeyPathsForPrefetching = ["hasCommits", "belongsToUser", "user"]
		self.init(fetchRequest: fetchRequest, managedObjectContext: NSManagedObjectContext.defaultContext(), sectionNameKeyPath: nil, cacheName: nil)
	}

	/**
		Finds a pull request

		- parameter indexPath: Returns the pull request found here
	*/
	func modelAtIndexPath(indexPath: NSIndexPath) -> PullRequest! {
		return objectAtIndexPath(indexPath) as! PullRequest
	}
   
}
