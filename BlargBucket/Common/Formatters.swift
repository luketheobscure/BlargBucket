//
//  Formatters.swift
//  BlargBucket
//
//  Created by Luke Deniston on 8/31/14.
//  Copyright (c) 2014 Luke Deniston. All rights reserved.
//

import UIKit

private let _singletonInstance = Formatters()

/**
	Date or string formatters
*/
class Formatters {

	/// Singleton Instance
	class var sharedInstance: Formatters {
		return _singletonInstance
	}

	/// Date formaetter for utc dates
	let utcDate: NSDateFormatter = ({
		var formatter = NSDateFormatter()
		formatter.dateFormat = "yyyy-mm-dd HH:mm:ssZ"
		return formatter
	})()

	/// Fixes image url's from BitBucket to get the full size url's
	func fixImgeURL(url: String) -> String {
		var mutableString = NSMutableString(string: url)
		imageURLSizeRegEx?.replaceMatchesInString(mutableString, options: NSMatchingOptions.WithoutAnchoringBounds, range: NSMakeRange(0, mutableString.length), withTemplate: ".png")
		return mutableString
	}
	let imageURLSizeRegEx = NSRegularExpression(pattern: "_16\\.png", options: NSRegularExpressionOptions.AllowCommentsAndWhitespace, error: nil)

}
