//
//  PullRequestViewController.swift
//  BlargBucket
//
//  Created by Luke Deniston on 10/16/14.
//  Copyright (c) 2014 Luke Deniston. All rights reserved.
//

import UIKit

class PullRequestViewController: UITableViewController {

	var pullRequest: PullRequest?
	let infoView = InfoViewController()
	var	reviewersViewController: ReviewersViewController?
	var viewModel: PullRequestViewModel?

    convenience init(aPullRequest: PullRequest){
		self.init(style: .Grouped)
		pullRequest = aPullRequest
		viewModel = PullRequestViewModel(aPullRequest: aPullRequest)
		reviewersViewController = ReviewersViewController(aPullRequest: aPullRequest)
		self.addChildViewController(reviewersViewController!)
	}

	override func viewDidLoad() {
		title = "Details"
		// TODO: Refactor into constants
		tableView.registerNib(UINib(nibName: "NormalTableViewCell", bundle: nil), forCellReuseIdentifier: "optionCell")
		tableView.registerNib(UINib(nibName: "ButtonTableViewCell", bundle: nil), forCellReuseIdentifier: "buttonCell")
	}

	override func viewWillAppear(animated: Bool) {
		tableView.tableHeaderView = infoView.view
		infoView.titleLabel?.text = pullRequest?.title
		if pullRequest?.belongsToUser.fullName() != nil {
			infoView.descriptionLabel.text = "Authored by \(pullRequest!.belongsToUser.fullName())"
		}
		infoView.setImage(UIImage(named: "user")!)
		var urlString = pullRequest?.belongsToUser.avatar
		if urlString != nil {
			let url = NSURL(string: urlString!)
			self.infoView.backgroundImageView.sd_setImageWithURL(url, placeholderImage: UIImage(named: "user"))
			self.infoView.imageView.sd_setImageWithURL(url, placeholderImage: UIImage(named: "user"))
		}
	}

    // MARK: - Table view data source

	override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		if section == 0 {
			return reviewersViewController?.collectionView
		}
		return nil
	}

	override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		if section == 0 {
			return 80
		}
		return 0
	}

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return viewModel?.sections.count ?? 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.sections[section].count ?? 0
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cellModel = viewModel!.tableCellModelAtPath(indexPath)
        let cell = tableView.dequeueReusableCellWithIdentifier(cellModel.reuseIdentifier, forIndexPath: indexPath) as UITableViewCell

        cell.textLabel.text = cellModel.title
		cell.detailTextLabel?.text = cellModel.detailTitle

        return cell
    }

	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		tableView.deselectRowAtIndexPath(indexPath, animated: true)
		let model = viewModel?.tableCellModelAtPath(indexPath)
		if let action = model?.action {
			action(view: self)
		}
	}
}
