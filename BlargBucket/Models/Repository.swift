//
//  Repository.swift
//  BlargBucket
//
//  Created by Luke Deniston on 8/14/14.
//  Copyright (c) 2014 Luke Deniston. All rights reserved.
//

import UIKit
import CoreData

/// Represents a BitBucket repository
public class Repository: BlargManagedObject {
	@NSManaged public var logo: NSString?
	@NSManaged public var is_private: NSNumber?
	@NSManaged public var name: NSString?
	@NSManaged public var owner: NSString?
	@NSManaged public var slug: NSString?
	@NSManaged public var url: NSString?
	@NSManaged public var scm: NSString?
	@NSManaged public var has_wiki: NSNumber?
	@NSManaged public var no_forks: NSNumber?
	@NSManaged public var email_mailinglist: NSString?
	@NSManaged public var is_mq: NSNumber?
	@NSManaged public var size: NSNumber?
	@NSManaged public var read_only: NSNumber?
	@NSManaged public var fork_of: NSString?
	@NSManaged public var mq_of: NSString?
	@NSManaged public var state: NSString?
	@NSManaged public var utc_created_on: NSDate?
	@NSManaged public var website: NSString?
	@NSManaged public var repo_description: NSString?
	@NSManaged public var has_issues: NSNumber?
	@NSManaged public var is_fork: NSNumber?
	@NSManaged public var language: NSString?
	@NSManaged public var utc_last_updated: NSDate?
	@NSManaged public var email_writers: NSNumber?
	@NSManaged public var no_public_forks: NSNumber?
	@NSManaged public var creator: NSString?
	@NSManaged public var resource_uri: NSString?
	@NSManaged public var uuid: String?

	public var full_name: String {
		get {
			if self.owner != nil && self.slug != nil {
				return "\(self.owner!)/\(self.slug!)"
			}
			return ""
		}
		set {
			var array = newValue.componentsSeparatedByString("/")
			self.owner = array[0]
			self.slug = array[1]
		}
	}

	/**
		Returns a repo or creates one if it doesn't exist.
		
		:param: url The url of the repo
		:param: context An optional NSManagedObjectContext
	*/
	public class func repoWithURL(url:AnyObject, context: NSManagedObjectContext = NSManagedObjectContext.defaultContext()) -> Repository {
		var repo = Repository.findFirstByAttribute("resource_uri", withValue: url) as? Repository
		if repo == nil {
			repo = Repository.createEntity() as Repository?
			repo!.resource_uri = url as? NSString
		}
		
		return repo!
	}

	/**
		Setter for `logo`. Fixes the url with `Formatters.fixImgeURL`
		
		:param: logo The logo url
	*/
	func setLogo(logo: NSString) {
		let newLogo = Formatters.sharedInstance.fixImgeURL(logo)

		self.willChangeValueForKey("logo")
		self.setPrimitiveValue(newLogo, forKey: "logo")
		self.didChangeValueForKey("logo")

	}

	func setUtc_created_on(date: AnyObject){
		let createdOnKey: String = "utc_created_on"
		checkAndSetDate(date, key: createdOnKey)
	}

	func setUtc_last_updated(date:AnyObject){
		let createdOnKey: String = "utc_last_updated"
		checkAndSetDate(date, key: createdOnKey)
	}


}