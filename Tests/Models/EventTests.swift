//
//  EventTests.swift
//  BlargBucket
//
//  Created by Luke Deniston on 12/18/14.
//  Copyright (c) 2014 Luke Deniston. All rights reserved.
//

import UIKit
import XCTest
import BlargBucket

class EventTests: BlargTest {
	lazy var event: Event = Event.importFromObject(Fixtures.fixtureForClass("Events", name: "Event1")) as! Event
	lazy var event2: Event = Event.importFromObject(Fixtures.fixtureForClass("Events", name: "Event2")) as! Event

	func testEventEvent(){
		XCTAssertEqual(event.event!, "pushed", "Event event was wrong.")
	}

	func testCreated(){
		XCTAssertNotNil(event.utc_created_on, "Created date not set")
	}

	func testNode(){
		XCTAssertEqual(event.node!, "hjgfhfhjfyjtfjhg", "Node was wrong.")
	}

	func testUser(){
		XCTAssertNotNil(event.belongsToUser, "No user.")
		XCTAssertEqual(event.belongsToUser!.username!, "derp", "Name wrong.")
	}

	func testCommits(){
		XCTAssertNotNil(event.hasCommits, "No commits")
		XCTAssertEqual(event.hasCommits!.count, 2, "Wrong number of commits.")
	}

	func testEventCount(){
		XCTAssertNotNil(event, "Event nil")
		XCTAssertNotNil(event2, "Event 2 nil")
		let allEvents = Event.findAll()
		XCTAssertEqual(allEvents.count, 2, "Didn't find all the events.")
	}

	func testShouldImport(){
		let badEvent = Fixtures.fixtureForClass("Events", name: "Event2")
		let goodEvent = Fixtures.fixtureForClass("Events", name: "Event1")
		let event = Event.createEntity() as! Event
		XCTAssertFalse(event.shouldImport(badEvent!), "Import should have failed")
		XCTAssertTrue(event.shouldImport(goodEvent!), "Import should have succeeded")
	}

}
