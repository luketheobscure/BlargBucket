//
//  CoreDataFixture.swift
//  BlargBucket
//
//  Created by Luke Deniston on 12/1/14.
//  Copyright (c) 2014 Luke Deniston. All rights reserved.
//

import Foundation
import CoreData

struct Fixtures {
	var context: NSManagedObjectContext = ({
		let coordinator = NSPersistentStoreCoordinator(managedObjectModel: CoreDataStack.sharedInstance.managedObjectModel)
		coordinator.addPersistentStoreWithType(NSInMemoryStoreType, configuration: nil, URL: nil, options: nil, error: nil)
		let moc = NSManagedObjectContext()
		moc.persistentStoreCoordinator = coordinator
		return moc
	})()
}

