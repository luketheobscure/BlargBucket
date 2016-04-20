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
	@NSManaged public var pullRequestID: NSNumber?
	@NSManaged public var title: String?
	@NSManaged public var pr_description: String?
	@NSManaged public var source_branch: String?
	@NSManaged public var destination_branch: String?
	@NSManaged public var diff_url: String?
	@NSManaged public var diff: String?
	@NSManaged public var string: String
	@NSManaged public var created_on: NSDate
	@NSManaged public var updated_on: NSDate

	@NSManaged public var belongsToUser: User
	@NSManaged public var belongsToRepository: Repository?
	@NSManaged public var hasCommits: NSSet?
	@NSManaged public var hasReviewers: NSSet?

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

	/**
		Returns the reviewers as an array sorted by `fullName` (it's stored as an NSSet)
	*/
	public func reviewersArray() -> [Reviewer]{
		var tempReviewers:[Reviewer] = []
		if hasReviewers != nil {
			for user in hasReviewers! {
				tempReviewers.append(user as! Reviewer)
			}
		}
		tempReviewers.sortInPlace({
			let name1:String? = $0.belongsToUser.display_name!.lowercaseString
			let name2:String? = $1.belongsToUser.display_name!.lowercaseString
			return name1 < name2
		})
		return tempReviewers
	}
}
