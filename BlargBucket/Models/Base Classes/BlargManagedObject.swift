//
//  BlargManagedObject.swift
//  BlargBucket
//
//  Created by Luke Deniston on 8/31/14.
//  Copyright (c) 2014 Luke Deniston. All rights reserved.
//

import UIKit
import CoreData

/**
	Main NSManagedObject subclass that all models should inherit from.
*/

@objc(BlargManagedObject)
public class BlargManagedObject: NSManagedObject {

	//TODO: Remove this

	/// DEPRECATED since we moved to MagicalRecord. This will get refactored out at some point.
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

	/// Makes this available to our test host. Just calls the MagicalRecord function `importFromObject` with the same arguments.
	public override class func importFromObject(data:AnyObject!) -> AnyObject {
		return super.importFromObject(data)
	}

	/// Temporary hack for XCTool tests (Travis)
	public class func testImportFromObject(data:AnyObject!) -> AnyObject {
		return super.MR_importFromObject(data)
	}

	/** 
		Workaround for a MagicalRecord bug.
	
		When magical record tries to get the entity name for a Swift class, it gets the full "BlargBucket.EntityName" which later causes issues. This splits that string and only returns the "EntityName" part.
	*/
	class func MR_entityName() -> String{
		return NSStringFromClass(self).componentsSeparatedByString(".").last as String!
	}
	
}
