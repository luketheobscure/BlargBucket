//
//  UserTests.swift
//  BlargBucket
//
//  Created by Luke Deniston on 12/1/14.
//  Copyright (c) 2014 Luke Deniston. All rights reserved.
//

import BlargBucket
import XCTest
import CoreData

class UserTests: BlargTest {

	func testUserWithUserName(){
		let userName = "derpMcDerp" as NSString
		let oldCount = allUsers()!.count
		let user = User.userWithUsername(userName, context: fixtures.context)

		XCTAssertEqual(userName, user.username!, "Username doesn't match")
		XCTAssertEqual(oldCount + 1, allUsers()!.count, "User count didn't change and it should have")

		let user2 = User.userWithUsername(userName, context: fixtures.context)
		XCTAssertEqual(oldCount + 1, allUsers()!.count, "User count changed and it shouldn't have")
	}

	func testFullName(){
		let userName = "derpMcDerp" as NSString
		let user = User.userWithUsername(userName, context: fixtures.context)
		user.first_name = "Luke"
		user.last_name = "McAwesomePants"
		XCTAssertEqual("Luke McAwesomePants", user.fullName())
	}

	func testEmptyFullName(){
		let userName = "derpMcDerp" as NSString
		let user = User.userWithUsername(userName, context: fixtures.context)
		XCTAssertEqual("derpMcDerp ", user.fullName())
	}

	func allUsers() -> [AnyObject]? {
		return fixtures.context.executeFetchRequest(NSFetchRequest(entityName: "User"), error: nil)
	}

}
