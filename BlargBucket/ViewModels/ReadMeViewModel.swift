//
//  ReadMeViewModel.swift
//  BlargBucket
//
//  Created by Nick Smillie on 12/23/14.
//  Copyright (c) 2014 Luke Deniston. All rights reserved.
//

import Foundation

class ReadMeViewModel: NSObject {
	
	dynamic var readMeAttributed: NSAttributedString?
	
	/**
	Fetch and parse the readme as soon as the view model is created
	*/
	override init(){
		super.init()
		DataFetcher.fetchReadMe(AppDelegate.sharedInstance().activeRepo!) {self.parseMarkDown($0)}
	}
	
	/**
	Parse readme in markdown to HTML, then set it up as an attributed string
	*/
	func parseMarkDown(readMeMarkDown: String?) {
		var markdownError: NSError?
		let readMeHTML = MMMarkdown.HTMLStringWithMarkdown(readMeMarkDown, error: &markdownError)
		if (markdownError != nil) {
			println(markdownError)
		}
		let attributedOptions = [NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType]
		var attributedStringError: NSError?
		if let encodedData = readMeHTML.dataUsingEncoding(NSUTF8StringEncoding) {
			self.readMeAttributed = NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil, error: &attributedStringError)
		}
		if (attributedStringError != nil) {
			println(attributedStringError)
		}
	}

}