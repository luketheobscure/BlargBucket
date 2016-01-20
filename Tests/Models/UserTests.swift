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

	lazy var user1 = User.importFromObject(Fixtures.fixtureForClass("Users", name:"Luke")) as! User

	func testUsername(){
		XCTAssertEqual(user1.username!, "lukederp", "Username is wrong")
	}

	func testDisplayName(){
		XCTAssertEqual(user1.display_name!, "Luke McLuke", "Display anme is wrong")
	}

	func testAvatar(){
		XCTAssertEqual(user1.avatar!, "https://secure.gravatar.com/avatar/4fdb6274fc7de4ef8fdc67ae6f7ed6dd?d=https%3A%2F%2Fd3oaxc4q5k2d6q.cloudfront.net%2Fm%2F6580bb2d7ce5%2Fimg%2Fdefault_avatar%2F32%2Fuser_blue.png&s=32", "Avatar is wrong")
	}

	func testCurrentUser(){
		XCTAssertNil(User.currentUser(), "Somethings weird. Shouldn't have gotten a user yet.")
		var currentUser = User.importFromObject(Fixtures.fixtureForClass("Users", name:"Luke")) as! User
		currentUser.makeCurrentUser()
		XCTAssertEqual(NSUserDefaults.standardUserDefaults().valueForKey("Current User") as! NSString, currentUser.username!, "Didn't set current user.")
		XCTAssertEqual(User.currentUser()!.username!, currentUser.username!, "Didn't get current user.")
	}

	func testUsernameIsUnique(){
		let luke = Fixtures.fixtureForClass("Users", name:"Luke")
		let oldCount = allUsers()!.count
		let user = User.importFromObject(Fixtures.fixtureForClass("Users", name: "Luke"))as! User

		XCTAssertEqual("lukederp", user.username!, "Username doesn't match")
		XCTAssertEqual(oldCount + 1, allUsers()!.count, "User count didn't change and it should have")

		let user2: AnyObject = User.importFromObject(Fixtures.fixtureForClass("Users", name: "Luke"))
		XCTAssertEqual(oldCount + 1, allUsers()!.count, "User count changed and it shouldn't have")

		let user3: AnyObject = User.importFromObject(Fixtures.fixtureForClass("Users", name: "Nick"))
		XCTAssertEqual(oldCount + 2, allUsers()!.count, "User count didn't change and it should have")
	}

	func testNiceName(){
		let luke = User.importFromObject(Fixtures.fixtureForClass("Users", name: "Luke")) as! User
		XCTAssertEqual(luke.niceName(), "Luke McLuke", "Nice name didn't get the display name")
		luke.display_name = nil
		XCTAssertEqual(luke.niceName(), "Luke McDuke", "Nice name didn't get the first and last name")
		luke.last_name = nil
		XCTAssertEqual(luke.niceName(), "Luke", "Nice name didn't get the first name")
		luke.first_name = nil
		XCTAssertEqual(luke.niceName(), "Anonymous", "Nice name didn't get the first name")


	}

	func allUsers() -> [AnyObject]? {
        do {
            return try NSManagedObjectContext.defaultContext().executeFetchRequest(NSFetchRequest(entityName: "User"))
        } catch {
            return nil
        }
	}

}
