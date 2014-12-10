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

	struct Commits {
		var LukesCommit = [
			"author": [
				"raw": "Luke <luke@gmail.com>",
				"user": [
					"display_name": "Luke Derp",
					"links": [
						"avatar": [
							"href": "https://secure.gravatar.com/avatar/b2d7ce5%2Fimg%2Fdefault_avatar%2F32%2Fuser_blue.png&s=32"
						],
						"html": [
							"href": "https://bitbucket.org/lukederp"
						],
						"self": [
							"href": "https://bitbucket.org/api/2.0/users/lukederp"
						],
					],
					"username": "lukederp",
					"uuid": "[07062011-699b-416d-949f-d8f88d89dba8]"
				],
			],
			"date": "2014-11-24T16:39:44+00:00",
			"hash": "835c27b49faf87d62f2947348821562b83580c",
			"message": "coffee-lint cleanup",
			"repository": [
				"full_name": "blargsoft/reposlug",
				"name": "reposlug",
				"uuid": "[632ff045-382b-46b5-a820-c7b840dcf90d]",
			]
		]
	}
}

