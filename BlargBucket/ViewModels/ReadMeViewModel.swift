//
//  ReadMeViewModel.swift
//  BlargBucket
//
//  Created by Nick Smillie on 12/23/14.
//  Copyright (c) 2014 Luke Deniston. All rights reserved.
//

import Foundation

class ReadMeViewModel: NSObject {
	
	dynamic var readMeMarkDown: String?
	var readMeAttributed: NSAttributedString?
	let repo = AppDelegate.sharedInstance().activeRepo
	
	/**
	Start fetching the readme as soon as the view model is created
	*/
	override init(){
		super.init()
		DataFetcher.fetchReadMe(repo!) {self.readMeMarkDown = $0}
	}
	
	/**
	Parse readme in markdown to HTML, then set it up as an attributed string
	*/
	func setAttributedString() {
		let readMeHTML = (MMMarkdown.HTMLStringWithMarkdown(self.readMeMarkDown, error: nil))
		let encodedData = readMeHTML.dataUsingEncoding(NSUTF8StringEncoding)
		let attributedOptions = [NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType]
		self.readMeAttributed = NSAttributedString(data: encodedData!, options: attributedOptions, documentAttributes: nil, error: nil)
	}

}