//
//  DataFetcher.swift
//  BlargBucket
//
//  Created by Luke Deniston on 8/13/14.
//  Copyright (c) 2014 Luke Deniston. All rights reserved.
//

import UIKit
import CoreData

private let _JSONManager: AFHTTPRequestOperationManager = {
	let manager = AFHTTPRequestOperationManager(baseURL: NSURL(string: "https://bitbucket.org"))
	manager.requestSerializer = AFJSONRequestSerializer(writingOptions:nil)
	return manager
}()

private let _plainTextManager: AFHTTPRequestOperationManager = {
	let manager = AFHTTPRequestOperationManager(baseURL: NSURL(string: "https://bitbucket.org"))
	//manager.requestSerializer = AFJSONRequestSerializer()
	manager.responseSerializer = AFHTTPResponseSerializer()
	return manager
	}()

class DataFetcher: NSObject {

	class var JSONManager: AFHTTPRequestOperationManager {
		return _JSONManager
	}

	class var plainTextManager: AFHTTPRequestOperationManager {
		return _plainTextManager
	}

	class func fetchURL(url:String, completion: (JSON: AnyObject) -> () ){
		println("Fetching URL: \(url)")
		DataFetcher.JSONManager.GET(url, parameters: nil, success: { (operation, JSON) -> Void in
			if JSON == nil {
				print("Error getting events: ")
				return
			}
			completion(JSON: JSON)
			var error = NSErrorPointer()
			CoreDataStack.sharedInstance.managedObjectContext.save(error)
			if error != nil {
				println("Core data error!")
				println(error)
			}
			}) { (operation, error) -> Void in
				println(error)
		}
	}

	class func postURL(url:String, completion: (JSON: AnyObject) -> () ){
		println("Posting URL: \(url)")
		DataFetcher.JSONManager.POST(url, parameters: nil, success: { (operation, JSON) -> Void in
			if JSON == nil {
				print("Error getting events: ")
				return
			}
			completion(JSON: JSON)
			var error = NSErrorPointer()
			CoreDataStack.sharedInstance.managedObjectContext.save(error)
			if error != nil {
				println("Core data error!")
				println(error)
			}
			}) { (operation, error) -> Void in
				println(error)
		}
	}

	// MARK: - API Requests

	class func loginAsUser() {
		DataFetcher.fetchURL("/api/1.0/user") {
			let userHash = $0["user"] as NSDictionary
			let userName = userHash["username"] as NSString
			var user = User.userWithUsername(userName)
			user.last_name = userHash["last_name"] as NSString?
			user.first_name = userHash["first_name"] as NSString?
			user.avatar = userHash["avatar"] as NSString?
			// TODO: Constantize "current user"
			NSUserDefaults.standardUserDefaults().setValue(userName, forKeyPath: "Current User")
		}
	}

	class func fetchRepoInfo(){
		DataFetcher.fetchURL("/api/1.0/user/repositories/") {
			var repos = $0 as NSArray
			for repo in repos {
				var aRepo: Repository = Repository.create(repo)
			}
		}
	}

	class func fetchEvents(repo: Repository){
		DataFetcher.fetchURL("/api/1.0/repositories/\(repo.owner!)/\(repo.slug!)/events/") { (JSON:AnyObject) in
			var events = JSON["events"] as NSArray
			for event in events {
				var anEvent = Event.newEvent()
				anEvent.event = event["event"] as NSString?

				let userHash = event["user"] as NSDictionary
				let userName = userHash["username"] as NSString
				var user = User.userWithUsername(userName)
				user.last_name = userHash["last_name"] as NSString?
				user.first_name = userHash["first_name"] as NSString?
				user.avatar = userHash["avatar"] as NSString?

				anEvent.belongsToUser = user
				anEvent.belongsToRepository = repo
				anEvent.setValue(event["utc_created_on"], forKey: "utc_created_on")

				let description: NSDictionary? = event["description"] as? NSDictionary
				let commits: NSArray? = description?["commits"] as? NSArray
				if commits != nil {
					var commitsForEvent:[Commit] = Array()
					for commit in commits! {
						let aCommit = Commit.commitWithHash(commit["hash"] as NSString, description: commit["description"] as NSString)
						commitsForEvent.append(aCommit)
					}
					anEvent.hasCommits = NSSet(array: commitsForEvent)
				}
			}
		}
	}

	// MARK: Pull Request Stuff

	class func fetchPullRequests(repo: Repository){
		DataFetcher.fetchURL("/api/2.0/repositories/\(repo.owner!)/\(repo.slug!)/pullrequests/") { (JSON:AnyObject) in
			var pullRequests = JSON["values"] as NSArray
			for pullRequestJSON in pullRequests {
				var pullRequest = PullRequest.createPullRequest(pullRequestJSON, repo: repo)
			}
		}
	}

	class func fetchPullRequestReviewers(pullRequest: PullRequest){
		let repo = pullRequest.belongsToRepository!
		DataFetcher.fetchURL("/api/1.0/repositories/\(repo.owner!)/\(repo.slug!)/pullrequests/\(pullRequest.id!)/participants") { (JSON:AnyObject) in
			var reviewers: [Reviewer] = []
			for reviewJSON in JSON as NSArray {
				let user = User.userWithUsername(reviewJSON["username"] as NSString)
				var reviewer = Reviewer(user: user, pullRequest: pullRequest)
				reviewer.approved = reviewJSON["approved"] as NSNumber
				reviewers.append(reviewer)
			}
			pullRequest.hasReviewers = NSSet(array: reviewers)
		}
	}

	class func fetchPullRequestDiff(pullRequest: PullRequest){
		let repo = pullRequest.belongsToRepository!
		// We expect this to 'fail'. BB returns a 403 with the correct url
		DataFetcher.JSONManager.GET("/api/2.0/repositories/\(repo.owner!)/\(repo.slug!)/pullrequests/\(pullRequest.id!)/diff", parameters: nil, success: nil) { (operation, error) -> Void in
			if operation.response != nil && operation.response.statusCode == 403 {
				DataFetcher.fetchDiff(operation.response.URL, pullRequest:pullRequest)
			} else {
				println(error)
			}
		}
	}

	class func fetchDiff(diffUrl:NSURL?, pullRequest: PullRequest){
		DataFetcher.plainTextManager.GET("\(diffUrl!)", parameters: nil, success:  { (operation, response) -> Void in
				var responseString = NSString(data: response as NSData, encoding: NSUTF8StringEncoding)
				pullRequest.diff = responseString
				CoreDataStack.sharedInstance.managedObjectContext.save(nil)
			})
			 { (operation, error) -> Void in
				println(operation)
		}
	}

	class func approvePullRequest(pullRequest: PullRequest){
		let repo = pullRequest.belongsToRepository!
		DataFetcher.postURL("/api/2.0/repositories/\(repo.owner!)/\(repo.slug!)/pullrequests/\(pullRequest.id!)/approve") { (JSON:AnyObject) in
			DataFetcher.fetchPullRequestReviewers(pullRequest)
		}
	}

	class func unaprovePullRequest(pullRequest: PullRequest){
		let repo = pullRequest.belongsToRepository!
		DataFetcher.JSONManager.DELETE("/api/2.0/repositories/\(repo.owner!)/\(repo.slug!)/pullrequests/\(pullRequest.id!)/approve", parameters: nil, success: { (operation, JSON) -> Void in
			if JSON == nil {
				print("Error getting events: ")
				return
			}
			DataFetcher.fetchPullRequestReviewers(pullRequest)
			var error = NSErrorPointer()
			CoreDataStack.sharedInstance.managedObjectContext.save(error)
			if error != nil {
				println("Core data error!")
				println(error)
			}
			}) { (operation, error) -> Void in
				println(error)
		}
	}

	// MARK: - Authorization
	class func setAuthToken(token:String) {
		DataFetcher.JSONManager.requestSerializer.setValue("Basic \(token)", forHTTPHeaderField: "Authorization")
		DataFetcher.plainTextManager.requestSerializer.setValue("Basic \(token)", forHTTPHeaderField: "Authorization")
	}

	class func clearAuthToken() {
		//TODO: Implement
		//Alamofire.Manager.sharedInstance.defaultHeaders.removeValueForKey("Authorization")
	}

}
