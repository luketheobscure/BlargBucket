//
//  KeychainService.swift
//  BlargBucket
//
//  Initial work done here:
//  http://matthewpalmer.net/blog/2014/06/21/example-ios-keychain-swift-save-query/
//


import UIKit
import Security

// Identifiers
let serviceIdentifier = "BlargBucket"
let userAccount = "authenticatedUser"
let accessGroup = "MySerivice"

// Arguments for the keychain queries
let kSecClassValue = kSecClass as NSString
let kSecAttrAccountValue = kSecAttrAccount as NSString
let kSecValueDataValue = kSecValueData as NSString
let kSecClassGenericPasswordValue = kSecClassGenericPassword as NSString
let kSecAttrServiceValue = kSecAttrService as NSString
let kSecMatchLimitValue = kSecMatchLimit as NSString
let kSecReturnDataValue = kSecReturnData as NSString
let kSecMatchLimitOneValue = kSecMatchLimitOne as NSString

class KeychainService: NSObject {

	/**
	* Exposed methods to perform queries.
	* Note: feel free to play around with the arguments
	* for these if you want to be able to customise the
	* service identifier, user accounts, access groups, etc.
	*/
	class func saveToken(token: NSString) {
		self.save(serviceIdentifier, data: token)
	}

	class func loadToken() -> NSString? {
		return self.load(serviceIdentifier)
	}

	class func deleteToken() {
		self.delete(serviceIdentifier)
	}

	/**
	* Internal methods for querying the keychain.
	*/
	private class func save(service: NSString, data: NSString) {
		var dataFromString: NSData = data.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!

		// Instantiate a new default keychain query
		var keychainQuery: NSMutableDictionary = NSMutableDictionary(objects: [kSecClassGenericPasswordValue, service, userAccount, dataFromString], forKeys: [kSecClassValue, kSecAttrServiceValue, kSecAttrAccountValue, kSecValueDataValue])

		// Delete any existing items
		SecItemDelete(keychainQuery as CFDictionaryRef)

		// Add the new keychain item
		var status: OSStatus = SecItemAdd(keychainQuery as CFDictionaryRef, nil)
	}

	private class func load(service: NSString) -> NSString? {
		// Instantiate a new default keychain query
		// Tell the query to return a result
		// Limit our results to one item
		var keychainQuery: NSMutableDictionary = NSMutableDictionary(objects: [kSecClassGenericPasswordValue, service, userAccount, kCFBooleanTrue, kSecMatchLimitOneValue], forKeys: [kSecClassValue, kSecAttrServiceValue, kSecAttrAccountValue, kSecReturnDataValue, kSecMatchLimitValue])

		var dataTypeRef :Unmanaged<AnyObject>?

		// Search for the keychain items
		let status: OSStatus = SecItemCopyMatching(keychainQuery, &dataTypeRef)

		let opaque = dataTypeRef?.toOpaque()

		var contentsOfKeychain: NSString?

		if let op = opaque? {
			let retrievedData = Unmanaged<NSData>.fromOpaque(op).takeUnretainedValue()

			// Convert the data retrieved from the keychain into a string
			contentsOfKeychain = NSString(data: retrievedData, encoding: NSUTF8StringEncoding)
		} else {
			println("Nothing was retrieved from the keychain. Status code \(status)")
		}

		return contentsOfKeychain
	}

	private class func delete(service: NSString) {
		var dataFromString: NSData = KeychainService.loadToken()!.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!

		// Instantiate a new default keychain query
		var keychainQuery: NSMutableDictionary = NSMutableDictionary(objects: [kSecClassGenericPasswordValue, service, userAccount, dataFromString], forKeys: [kSecClassValue, kSecAttrServiceValue, kSecAttrAccountValue, kSecValueDataValue])

		// Delete any existing items
		SecItemDelete(keychainQuery as CFDictionaryRef)
	}
}