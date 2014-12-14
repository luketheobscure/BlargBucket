//
//  PullRequest.swift
//  BlargBucket
//
//  Created by Luke Deniston on 8/20/14.
//  Copyright (c) 2014 Luke Deniston. All rights reserved.
//

import Foundation
import CoreData

/// A BitBucket Pull Request
public class PullRequest: BlargManagedObject, Diffable {

	// MARK: - Properties
	@NSManaged var id: NSNumber?
	@NSManaged var title: String?
	@NSManaged var pr_description: String?
	@NSManaged var source_branch: String?
	@NSManaged var destination_branch: String?
	@NSManaged var diff_url: String?
	@NSManaged var diff: String?
	@NSManaged var string: String
	@NSManaged var created_on: NSDate
	@NSManaged var updated_on: NSDate

	@NSManaged var belongsToUser: User
	@NSManaged var belongsToRepository: Repository?
	@NSManaged var hasCommits: NSSet?
	@NSManaged var hasReviewers: NSSet?

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
			println(newValue)
			self.diff = newValue
		}
	}

	/**
		Creates a PullRequest (the model, not an actual PR)
		
		:param: JSON A Dictionary object with all necessary info
		:param: repo The repository for the pull request
	*/
	class func createPullRequest(JSON: AnyObject, repo: Repository?) -> PullRequest {
		// TODO: Convert to MagicRecord
		var pullRequest = PullRequest.pullRequest(JSON["id"])
		pullRequest.title = JSON["title"] as? String
		pullRequest.pr_description = JSON["description"] as? String
		pullRequest.belongsToRepository = repo
		pullRequest.diff_url = JSON.valueForKeyPath("links.diff.href") as? String

		if JSON["author"] != nil{
			pullRequest.belongsToUser = User.importFromObject(JSON["author"]) as User
		}
		
		pullRequest.source_branch = JSON.valueForKeyPath("source.branch.name") as? String
		pullRequest.destination_branch = JSON.valueForKeyPath("destination.branch.name") as? String

		//TODO: Dates!!!!@!##*&

		return pullRequest
	}

	// MARK: - Functions

	/**
		Gets a local pull request
		
		:param: id The ID of the pull request
	*/
	class func pullRequest(id:AnyObject?) -> PullRequest {
		var user : PullRequest?
		let request = NSFetchRequest()
		request.entity = NSEntityDescription.entityForName("PullRequest", inManagedObjectContext: NSManagedObjectContext.defaultContext())
		request.predicate = NSPredicate(format: "id = '\(id!)'")
		var error = NSErrorPointer()
		let results = NSManagedObjectContext.defaultContext().executeFetchRequest(request, error: error) as Array?
		user = results?.last as? PullRequest

		if user == nil {
			let derp: AnyObject! = NSEntityDescription.insertNewObjectForEntityForName("PullRequest", inManagedObjectContext: NSManagedObjectContext.defaultContext())
			user =  derp as? PullRequest
			user!.id = id as? Int
		}

		return user!;
	}

	/**
		Returns the reviewers as an array sorted by `fullName` (it's stored as an NSSet)
	*/
	public func reviewersArray() -> [Reviewer]{
		var tempReviewers:[Reviewer] = []
		if hasReviewers != nil {
			for user in hasReviewers! {
				tempReviewers.append(user as Reviewer)
			}
		}
		tempReviewers.sort({
			var name1:String? = $0.belongsToUser.fullName().lowercaseString
			var name2:String? = $1.belongsToUser.fullName().lowercaseString
			return name1 < name2
		})
		return tempReviewers
	}
}
