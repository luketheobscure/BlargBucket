//
//  CommitsViewController.swift
//  BlargBucket
//
//  Created by Luke Deniston on 8/29/14.
//  Copyright (c) 2014 Luke Deniston. All rights reserved.
//

import UIKit

/// Lists all the pull requests
class CommitsViewController: BlargTable {

	 convenience init(aPullRequest: PullRequest){
		self.init(style: .Grouped)
		fetchedResults = CommitsViewModel(pullRequest: aPullRequest)
	}


	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		fetchedResults?.delegate = self
		let error = NSErrorPointer()
		do {
			try fetchedResults!.performFetch()
		} catch let error1 as NSError {
			error.memory = error1
		}

		if error != nil {
			print(error.debugDescription)
		}

		tableView.registerNib(UINib(nibName: "EventTableViewCell", bundle: nil), forCellReuseIdentifier: "reuseIdentifier")

		tableView.rowHeight = UITableViewAutomaticDimension
		tableView.estimatedRowHeight = 60.0

		title = "Commits"
	}

	func viewModel() -> CommitsViewModel {
		return fetchedResults as! CommitsViewModel
	}

	// MARK: - Table view data source
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let commit = viewModel().modelAtIndexPath(indexPath)
		let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! EventTableViewCell
		cell.accessoryType = .DisclosureIndicator

		cell.textLabel.text = commit.commit_description

		var name = NSLocalizedString("Anonymous", comment: "Anonymous")
		if let userName = commit.user?.niceName() {
			name = userName
		}

		if let date = commit.date {
			let prettyDate = Formatters.sharedInstance.prettyDate.stringFromDate(date)
			cell.detailTextLabel.text = "By \(name), \(prettyDate)"
		} else {
			cell.detailTextLabel.text = "By \(name)"
		}

		let url = commit.user?.avatar ?? ""
		cell.imageView.sd_setImageWithURL(NSURL(string: url as String), placeholderImage: UIImage(named: "user"))

		cell.setNeedsUpdateConstraints()
		cell.updateConstraintsIfNeeded()

		return cell
	}

	/// Pushes a `DiffViewController` based on the selected row, but does some network calls first
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		let commit = viewModel().modelAtIndexPath(indexPath)
		DataFetcher.fetchDiff(commit)
		navigationController?.pushViewController(DiffViewController(aDiffable: commit), animated: true)
	}
}
