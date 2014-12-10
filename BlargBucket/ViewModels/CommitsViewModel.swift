//
//  CommitsViewModel.swift
//  BlargBucket
//
//  Created by Luke Deniston on 12/9/14.
//  Copyright (c) 2014 Luke Deniston. All rights reserved.
//

import Foundation
import CoreData

/// Finds all the commits in a repository
class CommitsViewModel: NSFetchedResultsController {

	/**
	Designated initializer

	:param: repository The repository to find the pull requests for
	*/
	convenience init(pullRequest:PullRequest){
		let fetchRequest = Commit.requestAllWhere("belongsToPullRequest", isEqualTo: pullRequest)
		fetchRequest.sortDescriptors = [ NSSortDescriptor(key: "commit_hash", ascending: true) ]
		self.init(fetchRequest: fetchRequest, managedObjectContext: NSManagedObjectContext.defaultContext(), sectionNameKeyPath: nil, cacheName: nil)
	}

	/**
	Finds a pull request

	:param: indexPath Returns the pull request found here
	*/
	func modelAtIndexPath(indexPath: NSIndexPath) -> Commit! {
		return objectAtIndexPath(indexPath) as Commit
	}

}