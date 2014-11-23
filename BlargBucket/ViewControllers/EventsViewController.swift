//
//  EventsViewController.swift
//  BlargBucket
//
//  Created by Luke Deniston on 8/20/14.
//  Copyright (c) 2014 Luke Deniston. All rights reserved.
//

import UIKit

class EventsViewController: BlargTable {

	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		if AppDelegate.sharedInstance().activeRepo != nil {
			fetchedResults = EventsViewModel(repository: AppDelegate.sharedInstance().activeRepo!)
			fetchedResults?.delegate = self
			var error = NSErrorPointer()
			fetchedResults!.performFetch(error)
			tableView.registerNib(UINib(nibName: "EventTableViewCell", bundle: nil), forCellReuseIdentifier: "reuseIdentifier")
			if error != nil {
				println(error.debugDescription)
			}
		}

		tableView.rowHeight = UITableViewAutomaticDimension
		tableView.estimatedRowHeight = 60.0
		title = "Events"
	}

	func viewModel() -> EventsViewModel{
		return fetchedResults as EventsViewModel
	}

	// MARK: - Table view data source
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let event = viewModel().modelAtIndexPath(indexPath)
		let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as EventTableViewCell
		
		cell.textLabel.text = viewModel().eventTitle(event)
		cell.detailTextLabel.text = viewModel().eventCreated(event)

		let url = event.belongsToUser?.avatar ?? ""
		cell.imageView.sd_setImageWithURL(NSURL(string: url), placeholderImage: UIImage(named: "repoPlaceholder"))

		cell.setNeedsUpdateConstraints()
		cell.updateConstraintsIfNeeded()

		return cell
	}
}
