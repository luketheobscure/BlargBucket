//
//  DiffViewModel.swift
//  BlargBucket
//
//  Created by Luke Deniston on 10/11/14.
//  Copyright (c) 2014 Luke Deniston. All rights reserved.
//

import UIKit

/// View model for a diff.
class DiffViewModel: NSObject, UITableViewDataSource {

	/// The pull request to get the diff for
	var diffable: Diffable

	/// An array of `FileDiffViewModel`s
	var sections: [FileDiffViewModel]

	/**
		Designated initializer. Parses the raw diff string, then creates `FileDiffViewModel`s of the pieces. Finally populates `self.sections` with the result.
		
		:param: aDiffable Gets assigned to `self.diffable`
	*/
	init(aDiffable: Diffable) {
		diffable = aDiffable
		var expression = NSRegularExpression(pattern: "^diff", options: .AnchorsMatchLines, error: nil)
		if diffable.diffString != nil {
			let diff = diffable.diffString! as NSString
			let tempSections = diff.split(expression)
			for derp in tempSections {
				FileDiffViewModel(diff: derp as String)
			}
			sections = tempSections.map { FileDiffViewModel(diff: $0 as String) }
		} else {
			sections = []
		}

		super.init()
	}

	// MARK - UITableViewDataSource Protocol

	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return sections.count
	}

	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return sections[section].lines.count
	}

	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("DiffCell", forIndexPath: indexPath) as DiffTableViewCell
		let line: Line = sections[indexPath.section].lines[indexPath.row]
		cell.textLabel.text = line.text
		cell.prevLine.text = line.prevNumber
		cell.newLine.text = line.newNumber
		cell.backgroundColor = line.backgroundColor
		return cell
	}

	func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return sections[section].title
	}
}
