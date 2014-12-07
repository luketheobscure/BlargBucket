//
//  RepositoryInfoViewController.swift
//  BlargBucket
//
//  Created by Luke Deniston on 8/23/14.
//  Copyright (c) 2014 Luke Deniston. All rights reserved.
//

import UIKit
import QuartzCore

// TODO: Add documentation after we refactor

/// Shows the info about a single repository
class RepositoryInfoViewController: UITableViewController {

	var viewModel = RepositoryVM()
	var observer: AnyObject?
	var backgroundImage: UIImageView?
	// TODO: This is half refactored... lots of unnecesary stuff in here (like self.imageView, self.backgroungImage, etc)
	let topView = InfoViewController()
	var imageView: UIImageView?

    override func viewDidLoad() {
        super.viewDidLoad()
		tableView.registerNib(UINib(nibName: "NormalTableViewCell", bundle: nil), forCellReuseIdentifier: "reuseIdentifier")
		tableView.tableHeaderView = topView.view
		imageView = topView.imageView
		imageView?.layer.borderColor = UIColor.yellowish().CGColor
		imageView?.layer.borderWidth = 2

		backgroundImage = topView.backgroundImageView

        observer = NSNotificationCenter.defaultCenter().addObserverForName(Notifications().RepoChanged, object: nil, queue: nil, usingBlock: { (_) -> Void in
			self.viewModel = RepositoryVM()
			self.tableView.reloadData()
			self.setupInfoView()
		})

		self.setupInfoView()
		self.navigationItem.title = NSLocalizedString("Overview", comment: "Overview")
    }

	func setupInfoView() {
		var url = AppDelegate.sharedInstance().activeRepo?.logo ?? ""
		// TODO: Check for image first
		if url != "" {
			SDWebImageDownloader.sharedDownloader().downloadImageWithURL(NSURL(string: url), options: nil, progress: nil, completed: {[weak self] (image, data, error, finished) in
				if let wSelf = self {
					if image != nil {
						self?.backgroundImage?.image = image?
						self?.imageView?.image = image
					}
				}
			})
		}
		let textLabel = topView.titleLabel as UILabel
		let detailLabel = topView.descriptionLabel as UILabel

		textLabel.text = AppDelegate.sharedInstance().activeRepo?.name
		detailLabel.text = AppDelegate.sharedInstance().activeRepo?.repo_description

	}

	// MARK: - TableView stuff

	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 2
	}

	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return viewModel.info?.count ?? 0
	}

	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as UITableViewCell
		let model = indexPath.section == 0 ? viewModel.info![indexPath.row] : viewModel.standardOptions[indexPath.row]
		cell.textLabel?.text = model.title
		cell.detailTextLabel!.text = model.detailTitle
		return cell
	}

}
