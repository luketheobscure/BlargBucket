//
//  SettingsTableViewController.swift
//  BlargBucket
//
//  Created by Luke Deniston on 8/16/14.
//  Copyright (c) 2014 Luke Deniston. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		title = "Settings"
		tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
	}

	// MARK: - Table view data source

	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}

	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}


	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as UITableViewCell

		cell.textLabel.text = "Log Out"
		cell.textLabel.textColor = UIColor.yellowish()

		return cell
	}

	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		DataFetcher.clearAuthToken()
		Locksmith.deleteData(forKey: "password", inService:  "BlargService", forUserAccount: "BlargUser")
		AppDelegate.sharedInstance().window?.rootViewController = LoginViewController()
	}
}
