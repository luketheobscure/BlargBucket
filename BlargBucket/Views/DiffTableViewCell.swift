//
//  DiffTableViewCell.swift
//  BlargBucket
//
//  Created by Luke Deniston on 10/12/14.
//  Copyright (c) 2014 Luke Deniston. All rights reserved.
//

import UIKit

/// A `UITableViewCell` for showing a diff line
class DiffTableViewCell: UITableViewCell {

	/// Basically `textLabel` is an alias for this
	@IBOutlet weak var customTextLabel: UILabel!

	/// The previous line number in the diff
	@IBOutlet weak var prevLine: UILabel!

	/// The new line number in the diff
	@IBOutlet weak var newLine: UILabel!

	/// Shenanigans so we can use normal `textLabel`
	override var textLabel: UILabel {
		get {
			return self.customTextLabel
		}
	}

}
