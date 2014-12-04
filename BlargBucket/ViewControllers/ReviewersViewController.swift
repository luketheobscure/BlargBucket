//
//  ReviewersViewController.swift
//  BlargBucket
//
//  Created by Luke Deniston on 10/19/14.
//  Copyright (c) 2014 Luke Deniston. All rights reserved.
//

import UIKit
import CoreData

let reuseIdentifier = "Cell"


class ReviewersViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
	var reviewers: [Reviewer] = []
	var pullRequest: PullRequest?
	var observer: NSObjectProtocol?

	convenience init(aPullRequest:PullRequest) {
		let flowLayout = UICollectionViewFlowLayout()
		//flowLayout.minimumLineSpacing = 5
		flowLayout.scrollDirection = .Horizontal
		self.init(collectionViewLayout: flowLayout)
		reviewers = extractReviewers(aPullRequest)
		pullRequest = aPullRequest

		collectionView?.registerNib(UINib(nibName: "ReviewerCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
	}

	deinit {
		NSNotificationCenter.defaultCenter().removeObserver(observer!)
	}

    override func viewDidLoad() {
        super.viewDidLoad()
		let derp = UINib(nibName: "ReviewerCollectionViewCell", bundle: nil)
		collectionView?.registerNib(derp, forCellWithReuseIdentifier: reuseIdentifier)
		collectionView?.backgroundColor = UIColor.whiteColor()

		collectionView?.dataSource = self
		collectionView?.delegate = self
        observer = NSNotificationCenter.defaultCenter().addObserverForName(NSManagedObjectContextObjectsDidChangeNotification, object: CoreDataStack.sharedInstance.managedObjectContext, queue: nil, usingBlock: {  [unowned self](notification:NSNotification!) -> Void in
			if notification.userInfo![NSUpdatedObjectsKey] != nil {
				dispatch_async(dispatch_get_main_queue(), {
					self.reviewers = self.extractReviewers(self.pullRequest!)
					self.collectionView!.reloadData()
				})

			}
		})
    }

	func extractReviewers(pullRequest:PullRequest) -> [Reviewer] {
		var tempReviewers:[Reviewer] = []
		if pullRequest.hasReviewers != nil {
			for user in pullRequest.hasReviewers! {
				tempReviewers.append(user as Reviewer)
			}
		}
		tempReviewers.sort({
			var name1:String? = $0.belongsToUser.fullName().lowercaseString
			var name2:String? = $1.belongsToUser.fullName().lowercaseString
			return name1 < name2
		})
		return tempReviewers
	}

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return reviewers.count
    }

	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
		return CGSizeMake(65, 70)
	}

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as ReviewerCollectionViewCell
		let reviewer = reviewers[indexPath.row] as Reviewer
		let user = reviewer.belongsToUser


		cell.titleLabel.text = user.fullName()
		if user.avatar != nil {
			cell.avatarImageView?.sd_setImageWithURL(NSURL(string: user.avatar!))
		}

        return cell
    }

}
