//
//  RepositoriesViewModel.swift
//  BlargBucket
//
//  Created by Luke Deniston on 8/16/14.
//  Copyright (c) 2014 Luke Deniston. All rights reserved.
//

import UIKit
import CoreData

class RepositoriesViewModel: NSFetchedResultsController {

	var searchTerm: String? {
		set {
			if newValue != nil && newValue != ""{
				fetchRequest.predicate = NSPredicate(format: "name contains[cd] %@", newValue!)
			}
			var error = NSErrorPointer()
			performFetch(error)
			if error != nil {
				println(error)
			}
		}
		get {
			return self.searchTerm
		}
	}

	override init() {
		let fetchRequest = NSFetchRequest(entityName: "Repository")
		fetchRequest.sortDescriptors = [ NSSortDescriptor(key: "name", ascending: true, selector: "localizedCaseInsensitiveCompare:") ]
		super.init(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.sharedInstance.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
		DataFetcher.fetchRepoInfo()
	}

	func repoAtIndexPath(indexPath: NSIndexPath) -> Repository! {
		return objectAtIndexPath(indexPath) as Repository
	}
   
}
