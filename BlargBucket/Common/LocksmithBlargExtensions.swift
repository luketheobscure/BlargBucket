//
//  LocksmithBlargExtensions.swift
//  BlargBucket
//
//  Created by Luke Deniston on 1/1/15.
//  Copyright (c) 2015 Luke Deniston. All rights reserved.
//

import UIKit

/// The service identifier in the keychain.
private let service = "BlargService"
/// The key of our auth token... Used as both the key in the keychain and the key in the dictionary that it returns.
private let key = "AuthToken"
/// The "user account" of our service in the keychain. Not the current users user account.
private let userAccount = "Blarguser"

/**
	Contains extensions for working with Locksmith, so we don't have to specify service identifiers and stuff.
*/
extension Locksmith {

	/// Get the authToken we use in our networking credentials, or nil if none exists.
	class func getAuthToken() -> String? {
		let (dictionary, error) = Locksmith.loadData(forKey: key, inService: service, forUserAccount: userAccount)
		return dictionary?[key] as? String
	}

	/**
		Creates and stores the authToken

		:param: user The username

		:param: password The plain text password. This methods hashes it for you.

		:returns: The auth token so you don't have to retrieve it.
	*/
	class func createAuthToken(user: String, password: String) -> String {
		var hash : NSString = "\(user):\(password)" as NSString
		let data = hash.dataUsingEncoding(NSUTF8StringEncoding)
		let authToken = data!.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
		Locksmith.saveData([key: authToken], forKey: key, inService: service, forUserAccount: userAccount)
		return authToken
	}

	/// Deletes the auth token from the keychain.
	class func clearAuthToken(){
		Locksmith.deleteData(forKey: key, inService:  service, forUserAccount: userAccount)
	}
}