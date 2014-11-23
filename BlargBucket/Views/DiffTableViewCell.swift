//
//  DiffTableViewCell.swift
//  BlargBucket
//
//  Created by Luke Deniston on 10/12/14.
//  Copyright (c) 2014 Luke Deniston. All rights reserved.
//

import UIKit

class DiffTableViewCell: UITableViewCell {

	@IBOutlet weak var customTextLabel: UILabel!
	@IBOutlet weak var prevLine: UILabel!
	@IBOutlet weak var newLine: UILabel!

	override var textLabel: UILabel {
		get {
			return self.customTextLabel
		}
	}

}
