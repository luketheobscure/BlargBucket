//
//  PullRequestViewModel.swift
//  BlargBucket
//
//  Created by Luke Deniston on 11/7/14.
//  Copyright (c) 2014 Luke Deniston. All rights reserved.
//

import UIKit

/// A mostly static list of `TableCellModel`s for a pull request view
class PullRequestViewModel {

	/// A dreaded array of arrays that have `TableCellModel`s. The top tier of the array corresponds to tableView sections
	var sections: [[TableCellModel]] = []

	/// The pull request
	var pullRequest: PullRequest?

	/**
		Designated initializer. Populates self.sections
		
		:param: aPullRequest Gets set to self.pullRequest
	*/
	init(aPullRequest:PullRequest){
		pullRequest = aPullRequest
		let section1 = [
			TableCellModel(
				title: NSLocalizedString("Diff", comment: "Diff"),
				detailTitle: nil,
				imageView: nil,
				reuseIdentifier: "optionCell",
				action: { $0.navigationController!.pushViewController(DiffViewController(aDiffable: aPullRequest), animated: true) }
			),
			TableCellModel(
				title:NSLocalizedString("Commits", comment: "Commits"),
				detailTitle: nil,
				imageView: nil,
				reuseIdentifier: "optionCell",
				action: { $0.navigationController!.pushViewController(CommitsViewController(aPullRequest: aPullRequest), animated: true) }
			),
			TableCellModel(
				title:NSLocalizedString("Activity",
				comment: "Activity"),
				detailTitle: nil,
				imageView: nil,
				reuseIdentifier: "optionCell",
				action: nil
			)
		]
		let section2 = [
			self.approveCell(aPullRequest),
			TableCellModel(title:NSLocalizedString("Decline", comment: "Decline"), detailTitle: nil, imageView: nil, reuseIdentifier: "buttonCell", action: nil),
			TableCellModel(title:NSLocalizedString("Merge", comment: "Merge"), detailTitle: nil, imageView: nil, reuseIdentifier: "buttonCell", action: nil)
		]
		sections = [section1, section2]
	}

	/**
		Finds a `TableCellModel` in self.sections at an indexPath

		:param: indexPath The indexPath to look at
	*/
	func tableCellModelAtPath(indexPath:NSIndexPath) -> TableCellModel {
		return sections[indexPath.section][indexPath.row]
	}

	/**
		Returns a cell to either approve of unapprove a pull request. Checks if the current user has already approved it
		
		:param: pullRequest The pull request in question
	*/
	func approveCell(pullRequest: PullRequest) -> TableCellModel {
		if User.currentUser()!.hasApprovedPullRequest(pullRequest) {
			return TableCellModel(
				title:NSLocalizedString("Unapprove", comment: "Approve"),
				detailTitle: nil,
				imageView: nil,
				reuseIdentifier: "buttonCell",
				action: {
					let alertController = UIAlertController(title: "Approve", message: "Approve pull request \"\(pullRequest.title!)\"?", preferredStyle: .Alert)
					let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
					alertController.addAction(cancelAction)
					let OKAction = UIAlertAction(title: "Approve", style: .Default) { (action) in
						DataFetcher.unaprovePullRequest(pullRequest)
					}
					alertController.addAction(OKAction)
					$0.presentViewController(alertController, animated: true, completion: nil)
				}
			)
		}
		return TableCellModel(
			title:NSLocalizedString("Approve", comment: "Approve"),
			detailTitle: nil,
			imageView: nil,
			reuseIdentifier: "buttonCell",
			action: {
				let alertController = UIAlertController(title: "Unapprove", message: "Unapprove pull request \"\(pullRequest.title!)\"?", preferredStyle: .Alert)
				let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
				alertController.addAction(cancelAction)
				let OKAction = UIAlertAction(title: "Unapprove", style: .Default) { (action) in
					DataFetcher.approvePullRequest(pullRequest)
				}
				alertController.addAction(OKAction)
				$0.presentViewController(alertController, animated: true, completion: nil)
			}
		)
	}



}
