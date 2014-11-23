//
//  EventTableViewCell.swift
//  BlargBucket
//
//  Created by Luke Deniston on 8/22/14.
//  Copyright (c) 2014 Luke Deniston. All rights reserved.
//

import UIKit
import QuartzCore

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

	@IBOutlet weak var customImageView: UIImageView!
	@IBOutlet weak var customTextLabel: UILabel!
	@IBOutlet weak var customDetailLabel: UILabel!

//	var height: CGFloat?

	override func awakeFromNib() {
		super.awakeFromNib()
		imageView.frame = CGRectMake(0, 0, 44, 44)
		imageView.layer.cornerRadius = CGRectGetHeight(imageView.frame)/2
		imageView.clipsToBounds = true
		imageView.layer.borderColor = UIColor.badicalRed().CGColor
		imageView.layer.borderWidth = 2
		detailTextLabel.textColor = UIColor.seafoam()
	}

//	func layoutHeight() {
//		let constraintSize = CGSizeMake(236, 9999)
//		//var size = titleText.sizeWithAttributes([NSFontAttributeName: UIFont(name: "Avenir Next", size: 12)])
//		let text = textLabel.text as NSString!
//		var size = text.boundingRectWithSize(constraintSize, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: textLabel.font], context: nil)
//		if size.height > 17.0 {
//			height = 80
//			detailTextLabel.frame = CGRectMake(
//				CGRectGetMinX(detailTextLabel.frame),
//				CGRectGetMinY(detailTextLabel.frame) + 16,
//				CGRectGetWidth(detailTextLabel.frame),
//				CGRectGetHeight(detailTextLabel.frame)
//			)
//		} else {
//			height = 60
//		}
//	}


    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
