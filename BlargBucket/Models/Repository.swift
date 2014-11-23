//
//  Repository.swift
//  BlargBucket
//
//  Created by Luke Deniston on 8/14/14.
//  Copyright (c) 2014 Luke Deniston. All rights reserved.
//

import UIKit
import CoreData

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


	public class func create(JSON: AnyObject, context: NSManagedObjectContext = CoreDataStack.sharedInstance.managedObjectContext) -> Repository {
		var aRepo: Repository = Repository.repoWithURL(JSON["resource_uri"]!!, context: context)
		aRepo.name = JSON["name"] as? NSString
		for key in JSON as NSDictionary {
			if !(key.value is NSNull) {
				if key.key as NSString == "description" {
					aRepo.setValue(key.value, forKey: "repo_description")
				} else if aRepo.respondsToSelector(Selector(key.key as String)){
					aRepo.setValue(key.value, forKey: key.key as String)
				}
			}
		}

		return aRepo
	}

	public class func repoWithURL(url:AnyObject, context: NSManagedObjectContext = CoreDataStack.sharedInstance.managedObjectContext) -> Repository {
		var repo : Repository?
		let request = NSFetchRequest()
		request.entity = NSEntityDescription.entityForName(Repository.entityName(), inManagedObjectContext: context)
		request.predicate = NSPredicate(format: "resource_uri = '\(url)'")
		request.sortDescriptors = [NSSortDescriptor(key: "resource_uri", ascending: true)]
		var error = NSErrorPointer()
		var results = context.executeFetchRequest(request, error: error)
		if results?.count != 0 {
			var derp: AnyObject = results!.last!
			repo = derp as? Repository
		}

		if error != nil {
			println(error)
		}

		if repo == nil {
			let entity = NSEntityDescription.entityForName(Repository.entityName(), inManagedObjectContext: context)
			repo =  Repository(entity: entity!, insertIntoManagedObjectContext: context)
		}

		return repo!;
	}

	class func entityName() -> NSString {
		return "Repository"
	}

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