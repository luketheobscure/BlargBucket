//
//  InfoViewController.swift
//  BlargBucket
//
//  Created by Luke Deniston on 10/17/14.
//  Copyright (c) 2014 Luke Deniston. All rights reserved.
//

import UIKit

/// Shows a sweet info view with pictures and everything
class InfoViewController: UIViewController {

	/// The blurred out background image. Avoid setting this directly, use `setImage`
	@IBOutlet weak var backgroundImageView: UIImageView!

	/// The foreground image. Avoid setting this directly, use `setImage`
	@IBOutlet weak var imageView: UIImageView!

	/// The title label
	@IBOutlet weak var titleLabel: UILabel!

	/// The description label
	@IBOutlet weak var descriptionLabel: UILabel!

	/// Designated initializer
	override init() {
		super.init(nibName: "InfoView", bundle: nil)
	}

	override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
	}

	required init(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}

	override func viewDidLoad() {
		self.imageView?.layer.borderColor = UIColor.yellowish().CGColor
	}

	/// Sets both the foreground and background view.
	func setImage(image:UIImage){
		imageView.image = image
		backgroundImageView.image = image
	}
	
}
