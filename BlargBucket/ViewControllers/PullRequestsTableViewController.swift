//
//  PullRequestsTableViewController.swift
//  BlargBucket
//
//  Created by Luke Deniston on 8/29/14.
//  Copyright (c) 2014 Luke Deniston. All rights reserved.
//

import UIKit

class PullRequestsTableViewController: BlargTable {

	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		if AppDelegate.sharedInstance().activeRepo != nil {
			fetchedResults = PullRequestsViewModel(repository: AppDelegate.sharedInstance().activeRepo!)
			fetchedResults?.delegate = self
			var error = NSErrorPointer()
			fetchedResults!.performFetch(error)

			if error != nil {
				println(error.debugDescription)
			}

			tableView.registerNib(UINib(nibName: "EventTableViewCell", bundle: nil), forCellReuseIdentifier: "reuseIdentifier")
		}

		tableView.rowHeight = UITableViewAutomaticDimension
		tableView.estimatedRowHeight = 60.0

		title = "Pull Requests"
	}

	func viewModel() -> PullRequestsViewModel {
		return fetchedResults as PullRequestsViewModel
	}

	// MARK: - Table view data source
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let pullRequest = viewModel().modelAtIndexPath(indexPath)
		let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as EventTableViewCell

		cell.textLabel.text = pullRequest.title
		cell.detailTextLabel.text = pullRequest.pr_description

		let url = pullRequest.belongsToUser.avatar ?? ""
		cell.imageView.sd_setImageWithURL(NSURL(string: url), placeholderImage: UIImage(named: "repoPlaceholder"))

		cell.setNeedsUpdateConstraints()
		cell.updateConstraintsIfNeeded()

		return cell
	}

	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		let pullRequest = viewModel().modelAtIndexPath(indexPath)
		DataFetcher.fetchPullRequestDiff(pullRequest)
		DataFetcher.fetchPullRequestReviewers(pullRequest)
		//self.navigationController?.pushViewController(DiffViewController(aPullRequest: pullRequest), animated: true)
		self.navigationController?.pushViewController(PullRequestViewController(aPullRequest: pullRequest), animated: true)
	}

}
