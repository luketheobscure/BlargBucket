//
//  InfoViewController.swift
//  BlargBucket
//
//  Created by Luke Deniston on 10/17/14.
//  Copyright (c) 2014 Luke Deniston. All rights reserved.
//

import UIKit
@objc(InfoViewController)
class InfoViewController: UIViewController {

	@IBOutlet weak var backgroundImageView: UIImageView!
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var descriptionLabel: UILabel!
	@IBOutlet weak var titleLabel: UILabel!

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

	func setImage(image:UIImage){
		imageView.image = image
		backgroundImageView.image = image
	}
	
}
