//
//  DiffViewController.swift
//  BlargBucket
//
//  Created by Luke Deniston on 10/11/14.
//  Copyright (c) 2014 Luke Deniston. All rights reserved.
//

import UIKit

class DiffViewController: UITableViewController {

	var pullRequest: PullRequest?
	var viewModel: DiffViewModel?

	init(aPullRequest:PullRequest) {
		super.init(style: .Grouped)
		title = "Diff"
		pullRequest = aPullRequest
		viewModel = DiffViewModel(aPullRequest: aPullRequest)
		tableView.dataSource = viewModel
		tableView.separatorStyle = .None
		//tableView.separatorColor = UIColor.lightGrayColor()
		tableView.registerNib(UINib(nibName: "DiffTableViewCell", bundle: nil), forCellReuseIdentifier: "DiffCell")
		tableView.estimatedRowHeight = 24
		//tableView.separatorInset = UIEdgeInsetsZero
	}

	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
	}

	required init(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}

}
