//
//  SettingsTableViewController.swift
//  BlargBucket
//
//  Created by Luke Deniston on 8/16/14.
//  Copyright (c) 2014 Luke Deniston. All rights reserved.
//

import UIKit

/// Shows all the settings
class SettingsTableViewController: UITableViewController {

	let viewModel = SettingsViewModel()

	override init() {
		super.init(style: .Grouped)
	}

	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
	}

	required init(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		title = "Settings"
		tableView.registerNib(UINib(nibName: "NormalTableViewCell", bundle: nil), forCellReuseIdentifier: NormalTableViewCell.reuseIdentifier())
		tableView.registerNib(UINib(nibName: "ButtonTableViewCell", bundle: nil), forCellReuseIdentifier: ButtonTableViewCell.reuseIdentifier())
	}

	// MARK: - Table view data source

	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return viewModel.sections.count
	}

	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return viewModel.sections[section].count
	}

	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		var cellModel = viewModel.sections[indexPath.section][indexPath.row]
		let cell = tableView.dequeueReusableCellWithIdentifier(cellModel.reuseIdentifier, forIndexPath: indexPath) as UITableViewCell

		cell.textLabel?.text = cellModel.title
		cell.detailTextLabel?.text = cellModel.detailTitle

		return cell
	}

	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		var cellModel = viewModel.sections[indexPath.section][indexPath.row]
		if let action = cellModel.action {
			action(view: self)
		}
		tableView.deselectRowAtIndexPath(indexPath, animated: true)
	}
}
