//
//  BlargBucket.swift
//  BlargBucket
//
//  Created by Luke Deniston on 8/20/14.
//  Copyright (c) 2014 Luke Deniston. All rights reserved.
//

import Foundation
import CoreData


class Commit: NSManagedObject {

    @NSManaged var commit_hash: String?
    @NSManaged var commit_description: String?
    @NSManaged var belongsToRepository: Repository?

	class func commitWithHash(hash:String, description:String?) -> Commit {
		var commit : Commit?
		let request = NSFetchRequest()
		request.entity = NSEntityDescription.entityForName("Commit", inManagedObjectContext: CoreDataStack.sharedInstance.managedObjectContext)
		request.predicate = NSPredicate(format: "commit_hash = '\(hash)'")
		var error = NSErrorPointer()
		let results = CoreDataStack.sharedInstance.managedObjectContext.executeFetchRequest(request, error: error) as Array?
		commit = results!.last as? Commit

		if commit == nil {
			commit =  NSEntityDescription.insertNewObjectForEntityForName("Commit", inManagedObjectContext: CoreDataStack.sharedInstance.managedObjectContext) as? Commit
		}

		if description != nil {
			commit!.commit_description = description
		}

		return commit!
	}

}
