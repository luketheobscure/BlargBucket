//
//  PullRequest.swift
//  BlargBucket
//
//  Created by Luke Deniston on 8/20/14.
//  Copyright (c) 2014 Luke Deniston. All rights reserved.
//

import Foundation
import CoreData


class PullRequest: NSManagedObject {

	@NSManaged var id: NSNumber?
	@NSManaged var title: String?
	@NSManaged var pr_description: String?
	@NSManaged var source_branch: String?
	@NSManaged var destination_branch: String?
	@NSManaged var diff: String?
	@NSManaged var string: String
	@NSManaged var created_on: NSDate
	@NSManaged var updated_on: NSDate

	@NSManaged var belongsToUser: User
	@NSManaged var belongsToRepository: Repository?
	@NSManaged var hasCommits: NSSet?
	@NSManaged var hasReviewers: NSSet?

	class func createPullRequest(JSON: AnyObject, repo: Repository?) -> PullRequest {
		var pullRequest = PullRequest.pullRequest(JSON["id"])
		pullRequest.title = JSON["title"] as? String
		pullRequest.pr_description = JSON["description"] as? String
		pullRequest.belongsToRepository = repo
		
		var author = JSON.valueForKeyPath("author.username") as String?
		if author != nil{
			pullRequest.belongsToUser = User.userWithUsername(author!)
		}
		pullRequest.source_branch = JSON.valueForKeyPath("source.branch.name") as? String
		pullRequest.destination_branch = JSON.valueForKeyPath("destination.branch.name") as? String

		//TODO: Dates!!!!@!##*&

		return pullRequest
	}

	class func pullRequest(id:AnyObject?) -> PullRequest {
		var user : PullRequest?
		let request = NSFetchRequest()
		request.entity = NSEntityDescription.entityForName("PullRequest", inManagedObjectContext: CoreDataStack.sharedInstance.managedObjectContext)
		request.predicate = NSPredicate(format: "id = '\(id!)'")
		var error = NSErrorPointer()
		let results = CoreDataStack.sharedInstance.managedObjectContext.executeFetchRequest(request, error: error) as Array?
		user = results?.last as? PullRequest

		if user == nil {
			let derp: AnyObject! = NSEntityDescription.insertNewObjectForEntityForName("PullRequest", inManagedObjectContext: CoreDataStack.sharedInstance.managedObjectContext)
			user =  derp as? PullRequest
			user!.id = id as? Int
		}

		return user!;
	}

}
