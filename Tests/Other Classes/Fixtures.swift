//
// CoreDataFixture.swift
// BlargBucket
//
// Created by Luke Deniston on 12/1/14.
// Copyright (c) 2014 Luke Deniston. All rights reserved.
//

import Foundation
import CoreData
import BlargBucket

struct Fixtures {
	var context: NSManagedObjectContext = ({
		//return CoreDataStack.defaultContext()
		return NSManagedObjectContext.defaultContext()
	})()

	static func fixtureForClass(className:String, name:String) -> [String:AnyObject]? {
		NSBundle(forClass: BlargTest.self)
		let path = NSBundle(forClass: BlargTest.self).pathForResource(className, ofType: "yml")
		let content = NSString(contentsOfFile: path!, encoding: NSUTF8StringEncoding, error: nil)
		var error = NSErrorPointer()
		let yml: AnyObject! = YAMLSerialization.objectWithYAMLString(content, options: kYAMLReadOptionStringScalars, error: error)
		assert(error == nil)
		if let dictionary = yml[name] as? [String:AnyObject]{
			return dictionary
		}
		return nil
	}
}

