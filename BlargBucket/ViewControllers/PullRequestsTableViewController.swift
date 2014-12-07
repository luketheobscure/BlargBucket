//
//  PullRequestsTableViewController.swift
//  BlargBucket
//
//  Created by Luke Deniston on 8/29/14.
//  Copyright (c) 2014 Luke Deniston. All rights reserved.
//

import UIKit

/// Lists all the pull requests
class PullRequestsTableViewController: BlargTable {

	/// Sets up the view model based on the `AppDelegate.sharedInstance().activeRepo`
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

	/// Pushes a `PullRequestViewController` based on the selected row, but does some network calls first
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		let pullRequest = viewModel().modelAtIndexPath(indexPath)
		DataFetcher.fetchPullRequestDiff(pullRequest)
		DataFetcher.fetchPullRequestReviewers(pullRequest)
		self.navigationController?.pushViewController(PullRequestViewController(aPullRequest: pullRequest), animated: true)
	}

}
