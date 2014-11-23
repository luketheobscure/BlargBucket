//
//  RepositoriesTableViewController.swift
//  BlargBucket
//
//  Created by Luke Deniston on 8/16/14.
//  Copyright (c) 2014 Luke Deniston. All rights reserved.
//

import UIKit

class RepositoriesTableViewController: BlargTable, UISearchControllerDelegate, UISearchResultsUpdating {

	let searchController: UISearchController = ({
		let controller = UISearchController(searchResultsController: nil)
		controller.dimsBackgroundDuringPresentation = true
		controller.hidesNavigationBarDuringPresentation = false
		return controller
	})()

    override func viewDidLoad() {
        super.viewDidLoad()
		DataFetcher.fetchRepoInfo()
		fetchedResults = RepositoriesViewModel()
		fetchedResults?.delegate = self
		var error = NSErrorPointer()
		fetchedResults!.performFetch(error)

		if error != nil {
			println(error.debugDescription)
		}

		searchController.searchResultsUpdater = self
		searchController.searchBar.frame = CGRectMake(0.0, 0.0, CGRectGetWidth(self.tableView.frame), 44.0)
		self.tableView.tableHeaderView = searchController.searchBar

		title = "Repositories"
    }

	func searchBar(searchBar: UISearchBar!, textDidChange searchText: String!) {
		viewModel().searchTerm = searchText
		tableView.reloadData()
	}

	func viewModel() -> RepositoriesViewModel {
		return fetchedResults as RepositoriesViewModel
	}

    // MARK: - Table view data source
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		let repo = (fetchedResults as RepositoriesViewModel).repoAtIndexPath(indexPath)
		AppDelegate.sharedInstance().activeRepo = repo
		DataFetcher.fetchEvents(repo)
		self.dismissViewControllerAnimated(true, completion: nil)
	}

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath)-> UITableViewCell {
		// TODO: Need to dequeue here... But also set the style
		let cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "reuseIdentifier")

		let repo = (fetchedResults as RepositoriesViewModel).repoAtIndexPath(indexPath)

        cell.textLabel.text = repo.name
		let language = repo.language ?? ""
		cell.detailTextLabel!.text = language as NSString
		cell.imageView.sd_setImageWithURL(NSURL(string: repo.logo ?? ""), placeholderImage: UIImage(named: "repoPlaceholder"))
		cell.imageView.layer.cornerRadius = 22
		cell.imageView.clipsToBounds = true

		cell.textLabel.font = UIFont(name: "Avenir Next", size: 14)

        return cell
    }

	func updateSearchResultsForSearchController(searchController: UISearchController){
		self.viewModel().searchTerm = searchController.searchBar.text
		self.tableView.reloadData()
	}

}
