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
@objc
public class Commit: BlargManagedObject, Diffable {

	// MARK: - Properties
	@NSManaged public var commit_hash: String?
	@NSManaged public var commit_description: String?
	@NSManaged public var date: NSDate?
    @NSManaged public var belongsToRepository: Repository?
	@NSManaged public var belongsToPullRequest: PullRequest?
	@NSManaged public var user: User?
	@NSManaged public var diff_url: String?
	@NSManaged public var diff: String?

	// MARK: - Diffable protocol
	// See note in Diffable.swift
	public var diffUrlString: String? {
		get {
			return self.diff_url
		}
		set {
			self.diff_url = newValue
		}
	}

	public var diffString: String? {
		get {
			return self.diff
		}
		set {
			self.diff = newValue
		}
	}

	//MARK: - Functions

	/**
		Creates a commit
		
		- parameter hash: The git hash ID
		- parameter description: The git commit description
	*/
	class func commitWithHash(hash:String, description:String?) -> Commit {
		var commit : Commit?
		let request = NSFetchRequest()
		request.entity = NSEntityDescription.entityForName("Commit", inManagedObjectContext: NSManagedObjectContext.defaultContext())
		request.predicate = NSPredicate(format: "commit_hash = '\(hash)'")
		var error = NSErrorPointer()
        var results: Array<AnyObject>?! = nil
        do {
            results = try NSManagedObjectContext.defaultContext().executeFetchRequest(request) as Array?!
        } catch {
            print(error)
        }
		commit = results!!.last as? Commit

		if commit == nil {
			commit =  NSEntityDescription.insertNewObjectForEntityForName("Commit", inManagedObjectContext: NSManagedObjectContext.defaultContext()) as? Commit
		}

		if description != nil {
			commit!.commit_description = description
		}

		return commit!
	}

}
