//
//  DataFetcher.swift
//  BlargBucket
//
//  Created by Luke Deniston on 8/13/14.
//  Copyright (c) 2014 Luke Deniston. All rights reserved.
//

import UIKit
import CoreData
import AFNetworking

private let _JSONManager: AFHTTPRequestOperationManager = {
	let manager = AFHTTPRequestOperationManager(baseURL: NSURL(string: "https://bitbucket.org"))
	manager.requestSerializer = AFJSONRequestSerializer(writingOptions:[])
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
		
		- parameter url: The url to get
		- parameter completion: The completion block, gets passed the JSON from the network request
		- parameter failure: Optional failure completion handler
	*/
	class func fetchURL(url:String, completion: (JSON: AnyObject) -> (), failure: ((error: NSError?) -> ())? = nil){
		print("Fetching URL: \(url)")
		DataFetcher.JSONManager.GET(url, parameters: nil, success: { (operation, JSON) in
            guard let response = JSON else {
				print("Error getting JSON: ", terminator: "")
				if let failureHandler = failure {
					failureHandler(error: nil)
				}
				return
			}
            
			completion(JSON: response)
//			NSManagedObjectContext.defaultContext().saveToPersistentStoreWithCompletion({ (success, error) in
//				if (error != nil) {
//					print("Core data error!")
//					print(error)
//					if let failureHandler = failure {
//						failureHandler(error: error)
//					}
//				}
//			})
			}) { (operation, error) -> Void in
				print(error)
				if let failureHandler = failure {
					failureHandler(error: error)
				}
		}
	}

	/**
		Post methods in this class call this to do the heavy lifting

		- parameter url: The url to post to
		- parameter completion: The completion block, gets passed the JSON from the network request
	*/
	class func postURL(url:String, completion: (JSON: AnyObject) -> () ){
		print("Posting URL: \(url)")
		DataFetcher.JSONManager.POST(url, parameters: nil, success: { (operation, JSON) in
            guard let response = JSON else {
				print("Error getting JSON: ", terminator: "")
				return
			}
			completion(JSON: response)
			NSManagedObjectContext.defaultContext().saveToPersistentStoreWithCompletion({ (success, error) in
				if (error != nil) {
					print("Core data error!")
					print(error)
				}
			})			}) { (operation, error) in
				print(error)
		}
	}

	// MARK: - API Requests

	/**
		Gets the user info for the current user (based on the network authentication.
		Sets the username in NSUserDefaults for the key path "Current User"
	*/
	class func loginAsUser(result:(success:Bool, error: NSError?)->()) {
		DataFetcher.fetchURL("/api/1.0/user", completion: {
			let userHash = $0["user"] as! NSDictionary
			let user = User.importFromObject(userHash) as! User
			user.makeCurrentUser()
			result(success: true, error: nil)
		}, failure: {(error) in
			result(success: false, error: error)
		})
	}

	/// Gets all the repositories
	class func fetchRepoInfo(){
        DataFetcher.fetchURL("/api/1.0/user/repositories/", completion: {
            let repos = $0 as! NSArray
            for repo in repos {
                let aRepo: Repository = Repository.importFromObject(repo) as! Repository
                print(aRepo)
            }
        })
	}

	/**
		Gets all the events for a repository
		
		- parameter repo: The repository to get the events for
	*/
	class func fetchEvents(repo: Repository){
        DataFetcher.fetchURL("/api/1.0/repositories/\(repo.owner!)/\(repo.slug!)/events/", completion: { (JSON:AnyObject) in
            Event.deleteAll(repo)
            let events = JSON["events"] as! NSArray
            for eventJSON in events {
                let event = Event.importFromObject(eventJSON) as! Event
                event.belongsToRepository = repo
            }
        })
	}

	// MARK: Pull Request Stuff

	/**
		Gets all the pull requests for a given repo
		
		- parameter repo: The repository to get the pull requests for
	*/
	class func fetchPullRequests(repo: Repository){
		if let owner = repo.owner {
            DataFetcher.fetchURL("/api/2.0/repositories/\(owner)/\(repo.slug!)/pullrequests/", completion: { (JSON:AnyObject) in
                let pullRequests = JSON["values"] as! NSArray
                for pullRequestJSON in pullRequests {
                    let pullRequest = PullRequest.importFromObject(pullRequestJSON) as! PullRequest
                    pullRequest.belongsToRepository = repo
                }
            })
		}
	}

	/**
		Gets the reviewers for a pull request
		
		- parameter pullRequest: The pull request to get the reviewers for
	*/
	class func fetchPullRequestReviewers(pullRequest: PullRequest){
		let repo = pullRequest.belongsToRepository!
        DataFetcher.fetchURL("/api/1.0/repositories/\(repo.owner!)/\(repo.slug!)/pullrequests/\(pullRequest.pullRequestID!)/participants", completion: { (JSON:AnyObject) in
            var reviewers: [Reviewer] = []
            for reviewJSON in JSON as! NSArray {
                let user = User.importFromObject(reviewJSON) as! User
                //TODO: This creates a new reviewer everytime. That's bad, mmmm'K?
                let reviewer = Reviewer(user: user, pullRequest: pullRequest)
                reviewer.approved = reviewJSON["approved"] as! NSNumber
                reviewers.append(reviewer)
            }
            pullRequest.hasReviewers = NSSet(array: reviewers)
        })
	}

	/**
	Gets the commits for a pull request

	- parameter pullRequest: The pull request to get the commits for
	*/
	class func fetchPullRequestCommits(pullRequest: PullRequest){
		let repo = pullRequest.belongsToRepository!
        DataFetcher.fetchURL("/api/2.0/repositories/\(repo.owner!)/\(repo.slug!)/pullrequests/\(pullRequest.pullRequestID!)/commits", completion: { (JSON:AnyObject) in
//            var backgroundContext = NSManagedObjectContext.contextForCurrentThread()
            var commits: [Commit] = []
            
            //			var commits = Commit.importFromArray(JSON["values"] as NSArray)
            
            for commitJSON in JSON["values"] as! NSArray {
                let commit = Commit.createEntity() as! Commit
                commit.importValuesForKeysWithObject(commitJSON)
                commits.append(commit)
            }
            pullRequest.hasCommits = NSSet(array: commits)
        })
	}

	/**
		Gets the diff for a pull request, commit or other object. For PullRequests, Bitbucket will send us a 403 with the real URL in the response, so we set that to the diffUrlString then try this again.
		
		- parameter diffable: The object to get the diff for. Usually a pull request or a commit.
	*/
	class func fetchDiff(diffable: Diffable){
		// We expect this to 'fail'. BB returns a 403 with the correct url
		DataFetcher.plainTextManager.GET(diffable.diffUrlString!, parameters: nil, success: { (operation, response) -> Void in
			let responseString = NSString(data: response as! NSData, encoding: NSUTF8StringEncoding)
			diffable.diffString = String(responseString)
			NSManagedObjectContext.defaultContext().saveToPersistentStoreWithCompletion({ (success, error) -> Void in
				if (error != nil) {
					print("Core data error!")
					print(error)
				}
			})
		}) { (operation, error) -> Void in
			if operation.response != nil && operation.response.statusCode == 403 {
				diffable.diffUrlString = operation.response.URL?.absoluteString
				DataFetcher.fetchDiff(diffable)
			} else {
				print(error)
			}
		}
	}

	// MARK: Actions

	/**
		Marks a pull request as approved on BitBucket!
		
		- parameter The: pull request to approve
	*/
	class func approvePullRequest(pullRequest: PullRequest){
		let repo = pullRequest.belongsToRepository!
		DataFetcher.postURL("/api/2.0/repositories/\(repo.owner!)/\(repo.slug!)/pullrequests/\(pullRequest.pullRequestID!)/approve") { (JSON:AnyObject) in
			DataFetcher.fetchPullRequestReviewers(pullRequest)
		}
	}

	/**
		Marks a pull request as unapproved on BitBucket! Fetches the list of approvers when it finishes

		- parameter The: pull request to unapprove
	*/
	class func unaprovePullRequest(pullRequest: PullRequest){
		let repo = pullRequest.belongsToRepository!
		DataFetcher.JSONManager.DELETE("/api/2.0/repositories/\(repo.owner!)/\(repo.slug!)/pullrequests/\(pullRequest.pullRequestID!)/approve", parameters: nil, success: { (operation, JSON) -> Void in
            guard let _ = JSON else {
				print("Error getting events: ", terminator: "")
				return
			}
			DataFetcher.fetchPullRequestReviewers(pullRequest)
			NSManagedObjectContext.defaultContext().saveToPersistentStoreWithCompletion({ (success, error) -> Void in
				if (error != nil) {
					print("Core data error!")
					print(error)
				}
			})
		}) { (operation, error) -> Void in
			print(error)
		}
	}

	/**
		Declines a pull request on BitBucket, then refetched all the PR's to make sure everything is kosher.

		- parameter The: pull request to decline
	*/
	class func declinePullRequest(pullRequest: PullRequest){
		let repo = pullRequest.belongsToRepository!
		DataFetcher.JSONManager.POST("/api/2.0/repositories/\(repo.owner!)/\(repo.slug!)/pullrequests/\(pullRequest.pullRequestID!)/decline", parameters: nil, success: { (operation, JSON) -> Void in
			DataFetcher.fetchPullRequests(repo)
			}) { (operation, error) -> Void in
				print(error)
		}
	}

	/**
		Merges a pull request on Bitbucket, then refetches all the PR's. Note that the /merge API requires a merge message. This is hardcoded to BitBucket's default for now (with a signature from the app).
	
		- parameter The: pull request to merge
	*/
	class func mergePullRequest(pullRequest: PullRequest){
		let repo = pullRequest.belongsToRepository!
		let message = "Merged in \(pullRequest.source_branch!) (pull request #\(pullRequest.pullRequestID!))\n\n\(pullRequest.title!)\n\nMerged from BlargBucket"
		let params = ["message":"\(message)"]
		DataFetcher.JSONManager.POST("/api/2.0/repositories/\(repo.owner!)/\(repo.slug!)/pullrequests/\(pullRequest.pullRequestID!)/merge", parameters: params, success: { (operation, JSON) -> Void in
			DataFetcher.fetchPullRequests(repo)
			}) { (operation, error) -> Void in
				print(error)
		}
	}

	// MARK: - Authorization

	/**
		Sets the authorization token for our two AFHTTPRequestOperationManager's
		
		- parameter token: The auth token to set. Should be a base 64 of "username:password"
	*/
	class func setAuthToken(token:String) {
		DataFetcher.JSONManager.requestSerializer.setValue("Basic \(token)", forHTTPHeaderField: "Authorization")
		DataFetcher.plainTextManager.requestSerializer.setValue("Basic \(token)", forHTTPHeaderField: "Authorization")
	}

	/// Not implemented yet. Should clear the auth tokens out
	class func clearAuthToken() {
		DataFetcher.JSONManager.requestSerializer.setValue(nil, forHTTPHeaderField: "Authorization")
		DataFetcher.plainTextManager.requestSerializer.setValue(nil, forHTTPHeaderField: "Authorization")
	}

}
