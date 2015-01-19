//
//  Functions.swift
//  BlargBucket
//
//  Created by Luke Deniston on 1/18/15.
//  Copyright (c) 2015 Luke Deniston. All rights reserved.
//

/**
	Slightly shorter way of creating a localized string.
	
	:param: string The string to localize.
*/
func LocalizedString(string:String) -> NSString {
	return NSLocalizedString(string, comment: string)
}
