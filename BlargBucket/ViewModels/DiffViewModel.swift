//
//  DiffViewModel.swift
//  BlargBucket
//
//  Created by Luke Deniston on 10/11/14.
//  Copyright (c) 2014 Luke Deniston. All rights reserved.
//

import UIKit

class DiffViewModel: NSObject, UITableViewDataSource {
	var pullRequest: PullRequest
	var sections: [FileDiffViewModel]

	init(aPullRequest: PullRequest) {
		pullRequest = aPullRequest
		var expression = NSRegularExpression(pattern: "^diff", options: .AnchorsMatchLines, error: nil)
		if pullRequest.diff != nil {
			let diff = pullRequest.diff! as NSString
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

	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return sections.count
	}

	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return sections[section].lines.count
	}

	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		//let cell = UITableViewCell(style: .Value1, reuseIdentifier: "Derp")
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
