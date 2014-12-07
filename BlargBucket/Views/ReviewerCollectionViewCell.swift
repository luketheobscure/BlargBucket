//
//  ReviewerCollectionViewCell.swift
//  BlargBucket
//
//  Created by Luke Deniston on 10/22/14.
//  Copyright (c) 2014 Luke Deniston. All rights reserved.
//

import UIKit

/// A `UICollectionViewCell` with a round image and a small label
class ReviewerCollectionViewCell: UICollectionViewCell {

	/// The image
	@IBOutlet weak var avatarImageView: UIImageView?

	/// The label
	@IBOutlet weak var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        avatarImageView?.layer.cornerRadius = 25
		avatarImageView?.layer.borderWidth = 2
		avatarImageView?.layer.borderColor = UIColor.badicalRed().CGColor
    }

	override func prepareForReuse() {
		avatarImageView?.image = UIImage(named: "user")
	}

}
