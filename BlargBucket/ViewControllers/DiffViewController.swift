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

	/**
		Deisgnated initializer
		
		:param: aPullRequest The pull request to show the diff for
	*/
	init(aPullRequest:PullRequest) {
		super.init(style: .Grouped)
		title = "Diff"
		viewModel = DiffViewModel(aPullRequest: aPullRequest)
		tableView.dataSource = viewModel
		tableView.separatorStyle = .None
		tableView.registerNib(UINib(nibName: "DiffTableViewCell", bundle: nil), forCellReuseIdentifier: "DiffCell")
		tableView.estimatedRowHeight = 24
	}

	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
	}

	required init(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}

}
