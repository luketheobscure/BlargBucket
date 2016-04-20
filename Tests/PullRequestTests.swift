//
//  PullRequestTests.swift
//  BlargBucket
//
//  Created by Luke Deniston on 12/21/14.
//  Copyright (c) 2014 Luke Deniston. All rights reserved.
//

import UIKit
import XCTest
import BlargBucket

class PullRequestTests: BlargTest {

	lazy var pullRequest = PullRequest.importFromObject( Fixtures.fixtureForClass("PullRequests", name: "PullRequest") ) as! PullRequest
	lazy var pullRequest2 = PullRequest.importFromObject( Fixtures.fixtureForClass("PullRequests", name: "PullRequest2") ) as! PullRequest

	func testDescription(){
		XCTAssertEqual(pullRequest.pr_description!, "Derp request", "Description wrong")
	}

	func testID(){
		XCTAssertEqual(pullRequest.pullRequestID!, 1186, "id wrong")
	}

	func testSourceBranch(){
		XCTAssertEqual(pullRequest.source_branch!, "radbranch", "Description wrong")
	}

	func testDestinationBranch(){
		XCTAssertEqual(pullRequest.destination_branch!, "uberbranch", "destination_branch wrong")
	}

	func testDiffUrl(){
		XCTAssertEqual(pullRequest.diff_url!, "https://bitbucket.org/api/2.0/repositories/blargSoft/blargbucket/pullrequests/1186/diff", "diff_url wrong")
	}

	func testCreatedOn(){
		XCTAssertNotNil(pullRequest.created_on, "created_on nil")
	}
	func testUpdatedOn(){
		XCTAssertNotNil(pullRequest.updated_on, "updated_on nil")
	}

	func testbelongsToUser(){
		XCTAssertNotNil(pullRequest.belongsToUser, "belongsToUser nil")
	}

	func testCount(){
		XCTAssertNotNil(pullRequest, "PR 1 nil")
		XCTAssertNotNil(pullRequest2, "PR 2 nil")

		XCTAssertEqual(PullRequest.findAll().count, 2, "Didn't get 2 PR's")
	}
}
