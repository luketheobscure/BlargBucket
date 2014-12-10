//
//  CoreDataFixture.swift
//  BlargBucket
//
//  Created by Luke Deniston on 12/1/14.
//  Copyright (c) 2014 Luke Deniston. All rights reserved.
//

import Foundation
import CoreData
import BlargBucket

struct Fixtures {
	var context: NSManagedObjectContext = ({
		//return CoreDataStack.defaultContext()
		return NSManagedObjectContext.defaultContext()
	})()

	struct Users {
		var Luke = [
			"avatar": "https://secure.gravatar.com/avatar/4fdb6274fc7de4ef8fdc67ae6f7ed6dd?d=https%3A%2F%2Fd3oaxc4q5k2d6q.cloudfront.net%2Fm%2F6580bb2d7ce5%2Fimg%2Fdefault_avatar%2F32%2Fuser_blue.png&s=32",
			"display_name": "Luke McLuke",
			"first_name": "Luke",
			"is_staff": "0",
			"is_team": "0",
			"last_name": "McLuke",
			"resource_uri": "/1.0/users/lukederp",
			"username": "lukederp"
		]

		var Nick = [
			"avatar": "https://secure.gravatar.com/avatar/4fdb6274fc7de4ef8fdc67ae6f7ed6dd?d=https%3A%2F%2Fd3oaxc4q5k2d6q.cloudfront.net%2Fm%2F6580bb2d7ce5%2Fimg%2Fdefault_avatar%2F32%2Fuser_blue.png&s=32",
			"display_name": "Nick Derp",
			"first_name": "Nick",
			"is_staff": "0",
			"is_team": "0",
			"last_name": "Derp",
			"resource_uri": "/1.0/users/nickthederp",
			"username": "nickthederp"
		]
	}
}

