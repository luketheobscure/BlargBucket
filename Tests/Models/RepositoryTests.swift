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

	let repo1: Repository = Repository.importFromObject(Fixtures.fixtureForClass("Repositories", name: "Repo1")) as! Repository

	func testName(){
		XCTAssertEqual(repo1.name!, "blarg_bucket", "Name not equal")
	}

	func testDescription(){
		XCTAssertEqual(repo1.name!, "blarg_bucket", "Description not equal")
	}

	func testLanguage(){
		XCTAssertEqual("ruby", repo1.language!, "Repo description not correct.")
	}

	func testScm(){
		XCTAssertEqual("git", repo1.scm!, "Repo scm not correct.")
	}
    
    //TODO: Fix me
	func FAILING_testLastUpdated(){
		XCTAssertNotNil(repo1.utc_last_updated, "Last updated was nil")
	}

	func FAILING_testCreated(){
		XCTAssertNotNil(repo1.utc_created_on, "Last updated was nil")
	}

	func testCount() {
		let firstCount = allRepos()!.count
		let repository = Repository.importFromObject(Fixtures.fixtureForClass("Repositories", name: "Repo1")) as! Repository
		XCTAssertEqual(firstCount + 1, allRepos()!.count, "Count didn't go up and it should have")

		let repository2 = Repository.importFromObject(Fixtures.fixtureForClass("Repositories", name: "Repo1")) as! Repository
		XCTAssertEqual(firstCount + 1, allRepos()!.count, "Count went up and it shouldn't have")

		let repository3 = Repository.importFromObject(Fixtures.fixtureForClass("Repositories", name: "Repo2")) as! Repository
		XCTAssertEqual(firstCount + 2, allRepos()!.count, "Count didn't go up and it should have")
	}

	func testRepoWithURL(){
		let url = "deroderodero"
		let name = "Secret Chord Before The Lord" as NSString

		let secretRepo = Repository.repoWithURL(url, context: NSManagedObjectContext.defaultContext())
		secretRepo.name = name
		NSManagedObjectContext.defaultContext().save(nil)

		let blankRepo = Repository.repoWithURL("derp", context: NSManagedObjectContext.defaultContext())
		XCTAssertNil(blankRepo.name, "The name should be blank")

		let secretRepo2 = Repository.repoWithURL(url, context: NSManagedObjectContext.defaultContext())
		XCTAssertEqual(secretRepo2.name!, name, "The names don't match")
	}

	func testSetFullName(){
		repo1.full_name = "derp/mcderp"
		XCTAssertEqual(repo1.owner!, "derp", "Setting full name didn't set the owner")
		XCTAssertEqual(repo1.slug!, "mcderp", "Setting full name didn't set the slug")
	}

	func testGetFullName(){
		repo1.owner = "herp"
		repo1.slug = "mcherp"
		XCTAssertEqual(repo1.full_name, "herp/mcherp", "Setting full name didn't set the owner")
	}

	func allRepos() -> [AnyObject]? {
        do {
            return try NSManagedObjectContext.defaultContext().executeFetchRequest(NSFetchRequest(entityName: "Repository"))
        } catch {
            return nil
        }
	}

}
