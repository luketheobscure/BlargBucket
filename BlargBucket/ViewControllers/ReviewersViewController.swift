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

/// Collection view that shows the list of reviewers on a pull request
class ReviewersViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
	/// Array of reviewers
	var reviewers: [Reviewer] = []

	/// The pull request
	var pullRequest: PullRequest?

	/// Observer that updates the reviewers after they load
	var observer: NSObjectProtocol?

	/**
		Designated initializer

		:param: aPullRequest The pull request to show the info for
	*/
	convenience init(aPullRequest:PullRequest) {
		let flowLayout = UICollectionViewFlowLayout()
		//flowLayout.minimumLineSpacing = 5
		flowLayout.scrollDirection = .Horizontal
		self.init(collectionViewLayout: flowLayout)
		reviewers = aPullRequest.reviewersArray()
		pullRequest = aPullRequest

		collectionView?.registerNib(UINib(nibName: "ReviewerCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
	}

	/// Removes the observer
	deinit {
		NSNotificationCenter.defaultCenter().removeObserver(observer!)
	}

	/// Sets up the collection view and the observer
    override func viewDidLoad() {
        super.viewDidLoad()
		let nib = UINib(nibName: "ReviewerCollectionViewCell", bundle: nil)
		collectionView?.registerNib(nib, forCellWithReuseIdentifier: reuseIdentifier)
		collectionView?.backgroundColor = UIColor.whiteColor()

		collectionView?.dataSource = self
		collectionView?.delegate = self
        observer = NSNotificationCenter.defaultCenter().addObserverForName(NSManagedObjectContextObjectsDidChangeNotification, object: NSManagedObjectContext.defaultContext(), queue: nil, usingBlock: {  [unowned self](notification:NSNotification!) -> Void in
			if notification.userInfo![NSUpdatedObjectsKey] != nil {
				dispatch_async(dispatch_get_main_queue(), {
					self.reviewers = self.pullRequest!.reviewersArray()
					self.collectionView!.reloadData()
				})

			}
		})
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


		cell.titleLabel.text = user.display_name
		if user.avatar != nil {
			cell.avatarImageView?.sd_setImageWithURL(NSURL(string: user.avatar!))
		}

        return cell
    }

}
