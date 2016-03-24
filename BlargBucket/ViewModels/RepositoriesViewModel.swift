//
//  RepositoriesViewModel.swift
//  BlargBucket
//
//  Created by Luke Deniston on 8/16/14.
//  Copyright (c) 2014 Luke Deniston. All rights reserved.
//

import UIKit
import CoreData

/// Finds all the repositories.
class RepositoriesViewModel: NSFetchedResultsController {

	/// String to filter the repository name by. Updates the fetch request predicate.
	var searchTerm: String? {
		set {
			if newValue != nil && newValue != ""{
				fetchRequest.predicate = NSPredicate(format: "name contains[cd] %@", newValue!)
			}
            let error: NSErrorPointer = nil
			do {
				try performFetch()
			} catch let error1 as NSError {
				error.memory = error1
			}
			if error != nil {
				print(error)
			}
		}
		get {
			return self.searchTerm
		}
	}

	/// Designated initializer
	override init() {
		let fetchRequest = NSFetchRequest(entityName: "Repository")
		fetchRequest.sortDescriptors = [ NSSortDescriptor(key: "name", ascending: true, selector: #selector(NSString.localizedCaseInsensitiveCompare(_:))) ]
		super.init(fetchRequest: fetchRequest, managedObjectContext: NSManagedObjectContext.defaultContext(), sectionNameKeyPath: nil, cacheName: nil)
		DataFetcher.fetchRepoInfo()
	}

	/// Returns the repository at the index path
	func repoAtIndexPath(indexPath: NSIndexPath) -> Repository! {
		return objectAtIndexPath(indexPath) as! Repository
	}
   
}
