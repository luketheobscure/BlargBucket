//
//  EventTableViewCell.swift
//  BlargBucket
//
//  Created by Luke Deniston on 8/22/14.
//  Copyright (c) 2014 Luke Deniston. All rights reserved.
//

import UIKit
import QuartzCore

/// A `UITableViewCell` with a pretty round image on the left
class EventTableViewCell: UITableViewCell {
	override var imageView: UIImageView {
		get {
			return self.customImageView
		}
	}

	override var detailTextLabel: UILabel {
		get {
			return self.customDetailLabel
		}
	}

	override var textLabel: UILabel {
		get {
			return self.customTextLabel
		}
	}

	/// Basically an alias for `imageView`
	@IBOutlet weak var customImageView: UIImageView!

	/// Basically and alias for `textLabel`
	@IBOutlet weak var customTextLabel: UILabel!

	/// Basically and alias for `detailTextLabel`
	@IBOutlet weak var customDetailLabel: UILabel!

	override func awakeFromNib() {
		super.awakeFromNib()
		imageView.frame = CGRectMake(0, 0, 44, 44)
		imageView.layer.cornerRadius = CGRectGetHeight(imageView.frame)/2
		imageView.clipsToBounds = true
		imageView.layer.borderColor = UIColor.badicalRed().CGColor
		imageView.layer.borderWidth = 2
		detailTextLabel.textColor = UIColor.seafoam()
	}

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
