//
//  BlargTest.swift
//  BlargBucket
//
//  Created by Luke Deniston on 12/1/14.
//  Copyright (c) 2014 Luke Deniston. All rights reserved.
//
import XCTest
import BlargBucket
import MagicalRecord

class BlargTest: XCTestCase {
	var fixtures = Fixtures()

	override func setUp() {
		MagicalRecord.cleanUp()
		MagicalRecord.setupCoreDataStackWithInMemoryStore()
	}
}
