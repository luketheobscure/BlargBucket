//
//  LocksmithBlargExtensions.swift
//  BlargBucket
//
//  Created by Luke Deniston on 1/1/15.
//  Copyright (c) 2015 Luke Deniston. All rights reserved.
//

import UIKit
import Locksmith

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
	static func getAuthToken() -> String? {
//		let userData = Locksmith.loadDataForUserAccount(loadDataForUserAccount(userAccount, inService: service))
//            
//		return userData?[key] as? String
        
        guard let userData: [String : AnyObject] = Locksmith.loadDataForUserAccount(userAccount, inService: service) else {
            return "error"
        }
        
        return userData.first!.1 as? String
	}

	/**
		Creates and stores the authToken

		- parameter user: The username

		- parameter password: The plain text password. This methods hashes it for you.

		- returns: The auth token so you don't have to retrieve it.
	*/
	static func createAuthToken(user: String, password: String) -> String {
		let hash : NSString = "\(user):\(password)" as NSString
		let data = hash.dataUsingEncoding(NSUTF8StringEncoding)
		let authToken = data!.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
        do {
            try Locksmith.saveData([key: authToken], forUserAccount: userAccount, inService: service)
        } catch {
            print(error)
        }
		return authToken
	}

	/// Deletes the auth token from the keychain.
	static func clearAuthToken(){
        do {
            try Locksmith.deleteDataForUserAccount(userAccount, inService: service)
        } catch {
            print(error)
        }
	}
}