//
//  Repository.swift
//  BlargBucket
//
//  Created by Luke Deniston on 8/23/14.
//  Copyright (c) 2014 Luke Deniston. All rights reserved.
//

import UIKit

// TODO: Rename this

/// Sets up a list of `TableCellModels` for the repository info view
class RepositoryVM {

	/// Array of `TableCellModel`s with info about the `AppDelegate.sharedInstance().activeRepo`
	var info: [TableCellModel]?

	/// Static array of `TableCellModel`s with standard options
	let standardOptions : [TableCellModel] = [
		TableCellModel(title:NSLocalizedString("Read Me", comment: "Read Me"), detailTitle: nil, imageView: nil, reuseIdentifier: NormalTableViewCell.reuseIdentifier(), action: nil),
		TableCellModel(title:NSLocalizedString("Source", comment: "Source"), detailTitle: nil, imageView: nil, reuseIdentifier: NormalTableViewCell.reuseIdentifier(), action: nil),
		TableCellModel(title:NSLocalizedString("Commits", comment: "Commits"), detailTitle: nil, imageView: nil, reuseIdentifier: NormalTableViewCell.reuseIdentifier(), action: nil),
		TableCellModel(title:NSLocalizedString("Branches", comment: "Branches"), detailTitle: nil, imageView: nil, reuseIdentifier: NormalTableViewCell.reuseIdentifier(), action: nil)
	]

	/// Designated initializer
	init() {
		let repo = AppDelegate.sharedInstance().activeRepo
		if repo != nil {
			info = buildViewModel(repo!)
		} else {
			info = [];
		}
	}

	/**
		Used for populating `self.info`.
		
		- parameter repo: The repo to find the info for
	*/
	func buildViewModel(repo: Repository) -> [TableCellModel]? {
		return [
			TableCellModel(title: "Name", detailTitle: repo.name as? String, imageView: nil, reuseIdentifier: "derp", action: nil),
			TableCellModel(title: "Language", detailTitle: repo.language as? String, imageView: nil, reuseIdentifier: "derp", action: nil)
		]
	}

}
