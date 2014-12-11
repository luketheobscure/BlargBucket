//
//  BlargManagedObject.swift
//  BlargBucket
//
//  Created by Luke Deniston on 8/31/14.
//  Copyright (c) 2014 Luke Deniston. All rights reserved.
//

import UIKit
import CoreData

@objc(BlargManagedObject)
public class BlargManagedObject: NSManagedObject {
	func checkAndSetDate(date: AnyObject, key: String){
		var utc: AnyObject = date
		if utc is NSString {
			var string = utc as NSString
			utc = Formatters.sharedInstance.utcDate.dateFromString(string)!
		}
		self.willChangeValueForKey(key)
		self.setPrimitiveValue(utc, forKey: key )
		self.didChangeValueForKey(key)
	}

	public override class func importFromObject(data:AnyObject!) -> AnyObject {
		return super.importFromObject(data)
	}

	/// Workaround for a MagicalRecord bug
	class func MR_entityName() -> String{
		return NSStringFromClass(self).componentsSeparatedByString(".").last as String!
	}
	
}
