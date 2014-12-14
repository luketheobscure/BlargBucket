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
	manager.responseSerializer = AFHTTPResponseSerializer()
	return manager
	}()

/**
	Handles all the networking operations, basically used as a singleton.
	Most network operations getch a url, get some JSON, then parse it and populate our CoreData store
*/
class DataFetcher: NSObject {

	/// Singleton access for our AFHTTPRequestOperationManager with an AFJSONRequestSerializer
	class var JSONManager: AFHTTPRequestOperationManager {
		return _JSONManager
	}

	/// Singleton access for our AFHTTPRequestOperationManager without a JSON serializer
	class var plainTextManager: AFHTTPRequestOperationManager {
		return _plainTextManager
	}

	/**
		Most methods in this class call this to do the actual heavy lifting
		
		:param: url The url to get
		:param: completion The completion block, gets passed the JSON from the network request
	*/
	class func fetchURL(url:String, completion: (JSON: AnyObject) -> () ){
		println("Fetching URL: \(url)")
		DataFetcher.JSONManager.GET(url, parameters: nil, success: { (operation, JSON) -> Void in
			if JSON == nil {
				print("Error getting events: ")
				return
			}
			completion(JSON: JSON)
			NSManagedObjectContext.defaultContext().saveToPersistentStoreWithCompletion({ (success, error) -> Void in
				if (error != nil) {
					println("Core data error!")
					println(error)
				}
			})
			}) { (operation, error) -> Void in
				println(error)
		}
	}

	/**
		Post methods in this class call this to do the heavy lifting

		:param: url The url to post to
		:param: completion The completion block, gets passed the JSON from the network request
	*/
	class func postURL(url:String, completion: (JSON: AnyObject) -> () ){
		println("Posting URL: \(url)")
		DataFetcher.JSONManager.POST(url, parameters: nil, success: { (operation, JSON) -> Void in
			if JSON == nil {
				print("Error getting events: ")
				return
			}
			completion(JSON: JSON)
			NSManagedObjectContext.defaultContext().saveToPersistentStoreWithCompletion({ (success, error) -> Void in
				if (error != nil) {
					println("Core data error!")
					println(error)
				}
			})			}) { (operation, error) -> Void in
				println(error)
		}
	}

	// MARK: - API Requests

	/**
		Gets the user info for the current user (based on the network authentication.
		Sets the username in NSUserDefaults for the key path "Current User"
	*/
	class func loginAsUser() {
		DataFetcher.fetchURL("/api/1.0/user") {
			let userHash = $0["user"] as NSDictionary
			var user = User.importFromObject(userHash) as User
			// TODO: Constantize "current user"
			NSUserDefaults.standardUserDefaults().setValue(user.username, forKeyPath: "Current User")
		}
	}

	/// Gets all the repositories
	class func fetchRepoInfo(){
		DataFetcher.fetchURL("/api/1.0/user/repositories/") {
			var repos = $0 as NSArray
			for repo in repos {
				var aRepo: Repository = Repository.importFromObject(repo) as Repository
			}
		}
	}

	/**
		Gets all the events for a repository
		
		:param: repo The repository to get the events for
	*/
	class func fetchEvents(repo: Repository){
		DataFetcher.fetchURL("/api/1.0/repositories/\(repo.owner!)/\(repo.slug!)/events/") { (JSON:AnyObject) in
			var events = JSON["events"] as NSArray
			for event in events {
				var anEvent = Event.newEvent()
				anEvent.event = event["event"] as NSString?

				let userHash = event["user"] as NSDictionary
				var user = User.importFromObject(userHash) as User

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

	/**
		Gets all the pull requests for a given repo
		
		:param: repo The repository to get the pull requests for
	*/
	class func fetchPullRequests(repo: Repository){
		DataFetcher.fetchURL("/api/2.0/repositories/\(repo.owner!)/\(repo.slug!)/pullrequests/") { (JSON:AnyObject) in
			var pullRequests = JSON["values"] as NSArray
			for pullRequestJSON in pullRequests {
				var pullRequest = PullRequest.createPullRequest(pullRequestJSON, repo: repo)
			}
		}
	}

	/**
		Gets the reviewers for a pull request
		
		:param: pullRequest The pull request to get the reviewers for
	*/
	class func fetchPullRequestReviewers(pullRequest: PullRequest){
		let repo = pullRequest.belongsToRepository!
		DataFetcher.fetchURL("/api/1.0/repositories/\(repo.owner!)/\(repo.slug!)/pullrequests/\(pullRequest.id!)/participants") { (JSON:AnyObject) in
			var reviewers: [Reviewer] = []
			for reviewJSON in JSON as NSArray {
				let user = User.importFromObject(reviewJSON) as User
				//TODO: This creates a new reviewer everytime. That's bad, mmmm'K?
				var reviewer = Reviewer(user: user, pullRequest: pullRequest)
				reviewer.approved = reviewJSON["approved"] as NSNumber
				reviewers.append(reviewer)
			}
			pullRequest.hasReviewers = NSSet(array: reviewers)
		}
	}

	/**
	Gets the commits for a pull request

	:param: pullRequest The pull request to get the commits for
	*/
	class func fetchPullRequestCommits(pullRequest: PullRequest){
		let repo = pullRequest.belongsToRepository!
		DataFetcher.fetchURL("/api/2.0/repositories/\(repo.owner!)/\(repo.slug!)/pullrequests/\(pullRequest.id!)/commits") { (JSON:AnyObject) in
			var backgroundContext = NSManagedObjectContext.contextForCurrentThread()
			var commits: [Commit] = []

//			var commits = Commit.importFromArray(JSON["values"] as NSArray)

			for commitJSON in JSON["values"] as NSArray {
				var commit : Commit = Commit.createEntity() as Commit
				commit.importValuesForKeysWithObject(commitJSON)
				commits.append(commit)
			}
			pullRequest.hasCommits = NSSet(array: commits)
		}
	}

	/**
		Gets the diff for a pull request, commit or other object. For PullRequests, Bitbucket will send us a 403 with the real URL in the response, so we set that to the diffUrlString then try this again.
		
		:param: diffable The object to get the diff for. Usually a pull request or a commit.
	*/
	class func fetchDiff(diffable: Diffable){
		// We expect this to 'fail'. BB returns a 403 with the correct url
		DataFetcher.plainTextManager.GET(diffable.diffUrlString!, parameters: nil, success: { (operation, response) -> Void in
			var responseString = NSString(data: response as NSData, encoding: NSUTF8StringEncoding)
			diffable.diffString = responseString
			NSManagedObjectContext.defaultContext().saveToPersistentStoreWithCompletion({ (success, error) -> Void in
				if (error != nil) {
					println("Core data error!")
					println(error)
				}
			})
		}) { (operation, error) -> Void in
			if operation.response != nil && operation.response.statusCode == 403 {
				diffable.diffUrlString = operation.response.URL?.absoluteString
				DataFetcher.fetchDiff(diffable)
			} else {
				println(error)
			}
		}
	}

	// MARK: Actions

	/**
		Marks a pull request as approved on BitBucket!
		
		:param: The pull request to approve
	*/
	class func approvePullRequest(pullRequest: PullRequest){
		let repo = pullRequest.belongsToRepository!
		DataFetcher.postURL("/api/2.0/repositories/\(repo.owner!)/\(repo.slug!)/pullrequests/\(pullRequest.id!)/approve") { (JSON:AnyObject) in
			DataFetcher.fetchPullRequestReviewers(pullRequest)
		}
	}

	/**
		Marks a pull request as unapproved on BitBucket! Fetches the list of approvers when it finishes

		:param: The pull request to unapprove
	*/
	class func unaprovePullRequest(pullRequest: PullRequest){
		let repo = pullRequest.belongsToRepository!
		DataFetcher.JSONManager.DELETE("/api/2.0/repositories/\(repo.owner!)/\(repo.slug!)/pullrequests/\(pullRequest.id!)/approve", parameters: nil, success: { (operation, JSON) -> Void in
			if JSON == nil {
				print("Error getting events: ")
				return
			}
			DataFetcher.fetchPullRequestReviewers(pullRequest)
			NSManagedObjectContext.defaultContext().saveToPersistentStoreWithCompletion({ (success, error) -> Void in
				if (error != nil) {
					println("Core data error!")
					println(error)
				}
			})
		}) { (operation, error) -> Void in
			println(error)
		}
	}

	// MARK: - Authorization

	/**
		Sets the authorization token for our two AFHTTPRequestOperationManager's
		
		:param: token The auth token to set. Should be a base 64 of "username:password"
	*/
	class func setAuthToken(token:String) {
		DataFetcher.JSONManager.requestSerializer.setValue("Basic \(token)", forHTTPHeaderField: "Authorization")
		DataFetcher.plainTextManager.requestSerializer.setValue("Basic \(token)", forHTTPHeaderField: "Authorization")
	}

	/// Not implemented yet. Should clear the auth tokens out
	class func clearAuthToken() {
		//TODO: Implement
		//Alamofire.Manager.sharedInstance.defaultHeaders.removeValueForKey("Authorization")
	}

}
