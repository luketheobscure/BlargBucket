//
//  RepositoryModelTests.swift
//  BlargBucket
//
//  Created by Luke Deniston on 8/31/14.
//  Copyright (c) 2014 Luke Deniston. All rights reserved.
//

import UIKit
import CoreData
import XCTest
import BlargBucket

class RepositoryTests: BlargTest {

    func testCreateAndGet() {
		var JSON: AnyObject = [
			"created_on": "2013-09-27T22:08:47.506",
			"creator": "dirk_gently",
			"description": "Blarg Bucket",
			"email_mailinglist": "",
			"email_writers": 1,
			"fork_of": "<null>",
			"has_issues": 0,
			"has_wiki": 0,
			"is_fork": 0,
			"is_mq": 0,
			"is_private": 1,
			"language": "ruby",
			"last_updated": "2013-09-27T22:10:29.341",
			"logo": "https://d3oaxc4q5k2d6q.cloudfront.net/m/d2f44dcd176d/img/language-avatars/ruby_16.png",
			"mq_of": "<null>",
			"name": "blarg_bucket",
			"no_forks": 0,
			"no_public_forks": 1,
			"owner": "agrian",
			"read_only": 0,
			"resource_uri": "derp/derp/derp",
			"scm": "git",
			"size": 139703,
			"slug": "blarg_bucket",
			"state": "available",
			"utc_created_on": "2013-09-27 20:08:47+00:00",
			"utc_last_updated": "2013-09-27 20:10:29+00:00",
			"website": ""
		]

		let repository = Repository.create(JSON, context: fixtures.context)
		fixtures.context.save(nil)

		XCTAssertEqual(JSON["name"] as NSString, repository.name!, "Repo name not correct.")
		XCTAssertEqual(JSON["description"] as NSString, repository.repo_description!, "Repo description not correct.")
		XCTAssertEqual(JSON["language"] as NSString, repository.language!, "Repo description not correct.")
		XCTAssertEqual(JSON["scm"] as NSString, repository.scm!, "Repo scm not correct.")
		XCTAssertEqual(JSON["state"] as NSString, repository.state!, "Repo state not correct.")
		XCTAssertEqual(JSON["scm"] as NSString, repository.scm!, "Repo scm not correct.")

		XCTAssertNotNil(repository.utc_created_on, "Created on is nil")
		XCTAssertNotNil(repository.utc_last_updated, "Updated on is nil")

		let repository2 = Repository.repoWithURL(JSON["resource_uri"] as String, context: fixtures.context)

		XCTAssertEqual(JSON["name"] as NSString, repository2.name!, "Repo name not correct.")
		XCTAssertEqual(JSON["description"] as NSString, repository2.repo_description!, "Repo description not correct.")
		XCTAssertEqual(JSON["language"] as NSString, repository2.language!, "Repo description not correct.")
		XCTAssertEqual(JSON["scm"] as NSString, repository2.scm!, "Repo scm not correct.")
		XCTAssertEqual(JSON["state"] as NSString, repository2.state!, "Repo state not correct.")
		XCTAssertEqual(JSON["scm"] as NSString, repository2.scm!, "Repo scm not correct.")

		XCTAssertNotNil(repository2.utc_created_on, "Created on is nil")
		XCTAssertNotNil(repository2.utc_last_updated, "Updated on is nil")

    }

}
