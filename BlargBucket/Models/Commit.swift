//
//  BlargBucket.swift
//  BlargBucket
//
//  Created by Luke Deniston on 8/20/14.
//  Copyright (c) 2014 Luke Deniston. All rights reserved.
//

import Foundation
import CoreData

/// Represents a single git Commit
class Commit: BlargManagedObject {

    @NSManaged var commit_hash: String?
    @NSManaged var commit_description: String?
    @NSManaged var belongsToRepository: Repository?
	@NSManaged var belongsToPullRequest: PullRequest?

	/**
		Creates a commit
		
		:param: hash The git hash ID
		:param: description The git commit description
	*/
	class func commitWithHash(hash:String, description:String?) -> Commit {
		var commit : Commit?
		let request = NSFetchRequest()
		request.entity = NSEntityDescription.entityForName("Commit", inManagedObjectContext: NSManagedObjectContext.defaultContext())
		request.predicate = NSPredicate(format: "commit_hash = '\(hash)'")
		var error = NSErrorPointer()
		let results = NSManagedObjectContext.defaultContext().executeFetchRequest(request, error: error) as Array?
		commit = results!.last as? Commit

		if commit == nil {
			commit =  NSEntityDescription.insertNewObjectForEntityForName("Commit", inManagedObjectContext: NSManagedObjectContext.defaultContext()) as? Commit
		}

		if description != nil {
			commit!.commit_description = description
		}

		return commit!
	}

	/// Workaround for a MagicalRecord bug
	class func MR_entityName() -> String{
		return "Commit"
	}

}
