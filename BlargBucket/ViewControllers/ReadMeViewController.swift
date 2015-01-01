//
//  ReadMeViewController.swift
//  BlargBucket
//
//  Created by Nick Smillie on 1/1/15.
//  Copyright (c) 2015 Luke Deniston. All rights reserved.
//

import UIKit

class ReadMeViewController: UIViewController {
	
	@IBOutlet var textView: UITextView!
	
	var viewModel = ReadMeViewModel()
	
	/**
	Override initializer to set the nib and add an observer for fetching the readme
	*/
	override init() {
		super.init(nibName: "ReadMeView", bundle: nil)
		viewModel.addObserver(self, forKeyPath: "readMeMarkDown", options: .New, context: nil)
	}
	
	override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
	}
	
	required init(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	/**
	When viewModel finishes fetching the readme in its init, parse the markdown into an HTML attributed string and update the view
	*/
	override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
		if keyPath == "readMeMarkDown" {
			viewModel.setAttributedString()
			textView.attributedText = viewModel.readMeAttributed?
		}
	}
	
	/**
	Remove the observer when the view is destroyed
	*/
	deinit {
		viewModel.removeObserver(self, forKeyPath: "readMeMarkDown")
	}
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
