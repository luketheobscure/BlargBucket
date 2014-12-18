//
//  CommitTests.swift
//  BlargBucket
//
//  Created by Luke Deniston on 12/9/14.
//  Copyright (c) 2014 Luke Deniston. All rights reserved.
//

import XCTest
import BlargBucket

class CommitTests: BlargTest {

	let commit: Commit = Commit.importFromObject(Fixtures.fixtureForClass("Commits", name: "LukesCommit")) as Commit

	func testMessage(){
		XCTAssertEqual(commit.commit_description!, "coffee-lint cleanup", "Message not equal")
	}

	func testHash(){
		XCTAssertEqual(commit.commit_hash!, "835c27b49faf87d62f2947348821562b83580c", "Hash not equal")
	}

	func testDate(){
		XCTAssertNotNil(commit.date, "Date was nil")
	}

	func testUser(){
		XCTAssertNotNil(commit.user, "User was nil")
		XCTAssertEqual(commit.user!.username!, "lukederp", "User was nil")
	}
}
