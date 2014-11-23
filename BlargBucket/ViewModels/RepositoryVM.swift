//
//  Repository.swift
//  BlargBucket
//
//  Created by Luke Deniston on 8/23/14.
//  Copyright (c) 2014 Luke Deniston. All rights reserved.
//

import UIKit

class RepositoryVM {

	var info: [TableCellModel]?
	
	let standardOptions : [TableCellModel] = [
		TableCellModel(title:NSLocalizedString("Read Me", comment: "Read Me"), detailTitle: nil, imageView: nil, reuseIdentifier: "optionCell", action: nil),
		TableCellModel(title:NSLocalizedString("Source", comment: "Source"), detailTitle: nil, imageView: nil, reuseIdentifier: "optionCell", action: nil),
		TableCellModel(title:NSLocalizedString("Commits", comment: "Commits"), detailTitle: nil, imageView: nil, reuseIdentifier: "optionCell", action: nil),
		TableCellModel(title:NSLocalizedString("Branches", comment: "Branches"), detailTitle: nil, imageView: nil, reuseIdentifier: "optionCell", action: nil)
	]

	init() {
		let repo = AppDelegate.sharedInstance().activeRepo
		if repo != nil {
			info = buildViewModel(repo!)
		} else {
			info = [];
		}
	}

	func buildViewModel(repo: Repository) -> [TableCellModel]? {
		return [
			TableCellModel(title: "Name", detailTitle: repo.name, imageView: nil, reuseIdentifier: "derp", action: nil),
			TableCellModel(title: "Language", detailTitle: repo.language, imageView: nil, reuseIdentifier: "derp", action: nil)
		]
	}

}
