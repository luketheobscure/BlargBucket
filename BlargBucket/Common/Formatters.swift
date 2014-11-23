//
//  Formatters.swift
//  BlargBucket
//
//  Created by Luke Deniston on 8/31/14.
//  Copyright (c) 2014 Luke Deniston. All rights reserved.
//

import UIKit

private let _singletonInstance = Formatters()

class Formatters {

	class var sharedInstance: Formatters {
		return _singletonInstance
	}

	let utcDate: NSDateFormatter = ({
		var formatter = NSDateFormatter()
		formatter.dateFormat = "yyyy-mm-dd HH:mm:ssZ"
		return formatter
	})()

	let imageURLSizeRegEx = NSRegularExpression(pattern: "_16\\.png", options: NSRegularExpressionOptions.AllowCommentsAndWhitespace, error: nil)

	func fixImgeURL(url: String) -> String {
		var mutableString = NSMutableString(string: url)
		imageURLSizeRegEx?.replaceMatchesInString(mutableString, options: NSMatchingOptions.WithoutAnchoringBounds, range: NSMakeRange(0, mutableString.length), withTemplate: ".png")
		return mutableString
	}
}
