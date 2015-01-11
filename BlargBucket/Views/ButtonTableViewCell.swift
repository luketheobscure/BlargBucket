//
//  NormalTableViewCell.swift
//  BlargBucket
//
//  Created by Luke Deniston on 8/24/14.
//  Copyright (c) 2014 Luke Deniston. All rights reserved.
//

import UIKit

/// An actionable UITableViewCell
class ButtonTableViewCell: UITableViewCell {
	override var imageView: UIImageView {
		get {
			return self.customImageView
		}
	}

	override var textLabel: UILabel {
		get {
			return self.customTextLabel
		}
	}

	@IBOutlet weak var customImageView: UIImageView!
	@IBOutlet weak var customTextLabel: UILabel!


    override func awakeFromNib() {
        super.awakeFromNib()
		textLabel.textColor = UIColor.yellowish()

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

	class func reuseIdentifier() -> String { return "ButtonTableViewCellIdentifier" }
    
}
