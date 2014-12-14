//
//  Diffable.swift
//  BlargBucket
//
//  Created by Luke Deniston on 12/13/14.
//  Copyright (c) 2014 Luke Deniston. All rights reserved.
//

/**
	Protocol for storing information about a diff.

	Two things that kind of suck:
		- As of XCode 6.1.1, There's some kind of bug between the @NSManaged directive, protocols, and the compiler, so we can't set these as actual @NSManaged properties in out models, thus the weird names
		- We have to add the @objc or else the compiler won't let us assign back to these variables, despite having defined setters.
*/

@objc
public protocol Diffable {

	/// The url of the diff
	var diffUrlString: String? { get set }

	/// The raw text of the diff
	var diffString: String? { get set }
}
