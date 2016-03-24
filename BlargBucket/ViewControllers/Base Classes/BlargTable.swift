//
//  BlargTable.swift
//  BlargBucket
//
//  Created by Luke Deniston on 8/20/14.
//  Copyright (c) 2014 Luke Deniston. All rights reserved.
//

import UIKit
import CoreData

/**
	Eliminates some of the boilerplate of UITableViewController + NSFetchedResultsController
*/
class BlargTable: UITableViewController, NSFetchedResultsControllerDelegate {

	/// The very important NSFetchedResultsController. Needs to be assigned when the class is instantiated.
	var fetchedResults: NSFetchedResultsController?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return fetchedResults?.sections?.count ?? 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if (fetchedResults != nil) {
			let value = fetchedResults!.sections?[section].numberOfObjects ?? 0
			return value
		}
        return 0
    }

	// MARK: - NSFetchedResultsControllerDelegate

	func controllerWillChangeContent(controller: NSFetchedResultsController) {
		tableView.beginUpdates()
	}

	func controllerDidChangeContent(controller: NSFetchedResultsController) {
		tableView.endUpdates()
	}

	func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
		switch(type) {
			case .Insert:
				tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
				break

			case .Delete:
				tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
				break

			default:
				break
		}
	}

	func blargTableController(controller: NSFetchedResultsController!, didChangeObject anObject: NSManagedObject!, atIndexPath indexPath: NSIndexPath!, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath!) {
		switch(type) {
			case .Insert:
				tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: UITableViewRowAnimation.Fade)
				break;

			case .Delete:
				tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
				break;

			case .Update:
				//[self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
				break;

			case .Move:
	//			[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
	//			[tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
				break;
		}
	}
}
