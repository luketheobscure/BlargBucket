//
//  PullRequestViewModel.swift
//  BlargBucket
//
//  Created by Luke Deniston on 11/7/14.
//  Copyright (c) 2014 Luke Deniston. All rights reserved.
//

import UIKit

class PullRequestViewModel {

	var sections: [[TableCellModel]] = []
	var pullRequest: PullRequest?

	init(aPullRequest:PullRequest){
		pullRequest = aPullRequest
		let section1 = [
			TableCellModel(
				title: NSLocalizedString("Diff", comment: "Diff"),
				detailTitle: nil,
				imageView: nil,
				reuseIdentifier: "optionCell",
				action: { $0.navigationController!.pushViewController(DiffViewController(aPullRequest: aPullRequest), animated: true) }
			),
			TableCellModel(
				title:NSLocalizedString("Commits", comment: "Commits"),
				detailTitle: nil,
				imageView: nil,
				reuseIdentifier: "optionCell",
				action: nil
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

	func tableCellModelAtPath(indexPath:NSIndexPath) -> TableCellModel {
		return sections[indexPath.section][indexPath.row]
	}

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
