//
//  DiffViewController.swift
//  BlargBucket
//
//  Created by Luke Deniston on 10/11/14.
//  Copyright (c) 2014 Luke Deniston. All rights reserved.
//

import UIKit

/// Displays the diff of a pull request
class DiffViewController: UITableViewController {

	/// Set as the table view dataSource
	var viewModel: DiffViewModel?

	/// Observer that updates the table after the diff loads
	var observer: NSObjectProtocol?

	var diffable: Diffable?

	/**
		Deisgnated initializer
		
		:param: adiffable The pull request to show the diff for
	*/
	init(aDiffable:Diffable) {
		super.init(style: .Grouped)
		title = "Diff"
		diffable = aDiffable
		setupViewModel(aDiffable)
		tableView.separatorStyle = .None
		tableView.registerNib(UINib(nibName: "DiffTableViewCell", bundle: nil), forCellReuseIdentifier: "DiffCell")
		tableView.estimatedRowHeight = 24
	}

	/// Sets up the observer
	override func viewDidLoad() {
		observer = NSNotificationCenter.defaultCenter().addObserverForName(NSManagedObjectContextObjectsDidChangeNotification, object: NSManagedObjectContext.defaultContext(), queue: nil, usingBlock: {  [unowned self](notification:NSNotification!) -> Void in
			if notification.userInfo![NSUpdatedObjectsKey] != nil && (notification.userInfo![NSUpdatedObjectsKey] as NSSet).containsObject(self.diffable!){
				dispatch_async(dispatch_get_main_queue(), {
					self.setupViewModel(self.diffable!)
					self.tableView.reloadData()
				})

			}
		})
	}

	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
	}

	required init(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}

	/**
		Sets up the viewModel and sets the `tableview.datasource`
		
		:param: aDiffable The pull request to be passed to the viewModel
	*/
	func setupViewModel(aDiffable:Diffable){
		viewModel = DiffViewModel(aDiffable: aDiffable)
		tableView.dataSource = viewModel
	}

	/// Removes the observer
	deinit {
		NSNotificationCenter.defaultCenter().removeObserver(observer!)
	}

}
