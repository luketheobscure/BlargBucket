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
		let content = try? NSString(contentsOfFile: path!, encoding: NSUTF8StringEncoding)
		var error = NSErrorPointer()
		var yml: AnyObject! = nil
        do {
            yml = try YAMLSerialization.objectWithYAMLString(content as! String, options: kYAMLReadOptionStringScalars)
        } catch {
            print(error)
        }
		assert(error == nil)
        let dict = yml as! [String:AnyObject]
        if let dictionary = dict[name] {
            return dictionary as? [String : AnyObject]
		}
		return nil
	}
}

