//
//  CoreDataStack.swift
//  BlargBucket
//
//  Created by Luke Deniston on 8/31/14.
//  Copyright (c) 2014 Luke Deniston. All rights reserved.
//

import UIKit
import CoreData

private var _coreDataStackInstance = CoreDataStack()

public class CoreDataStack {

	public class var sharedInstance: CoreDataStack {
		return _coreDataStackInstance
	}

	public lazy var managedObjectModel: NSManagedObjectModel = {
		let modelURL = NSBundle.mainBundle().URLForResource("Model", withExtension: "momd")
		return NSManagedObjectModel(contentsOfURL: modelURL!)!
	}()

}
