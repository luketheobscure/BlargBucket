//
//  RepositoriesTableViewController.swift
//  BlargBucket
//
//  Created by Luke Deniston on 8/16/14.
//  Copyright (c) 2014 Luke Deniston. All rights reserved.
//

import UIKit

/// Lists all the repositorues
class RepositoriesTableViewController: BlargTable, UISearchControllerDelegate, UISearchResultsUpdating {

	/// The search controller for the search box
	let searchController: UISearchController = ({
		let controller = UISearchController(searchResultsController: nil)
		controller.dimsBackgroundDuringPresentation = true
		controller.hidesNavigationBarDuringPresentation = false
		return controller
	})()

	/// Sets up the view model, the search controller, and fetched the relevant ingo.
    override func viewDidLoad() {
        super.viewDidLoad()
		DataFetcher.fetchRepoInfo()
		fetchedResults = RepositoriesViewModel()
		fetchedResults?.delegate = self
        let error: NSErrorPointer = nil
		do {
			try fetchedResults!.performFetch()
		} catch let error1 as NSError {
			error.memory = error1
		}

		if error != nil {
			print(error.debugDescription)
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
		return fetchedResults as! RepositoriesViewModel
	}

    // MARK: - Table view data source
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		let repo = (fetchedResults as! RepositoriesViewModel).repoAtIndexPath(indexPath)
		AppDelegate.sharedInstance().activeRepo = repo
		DataFetcher.fetchEvents(repo)
		self.dismissViewControllerAnimated(true, completion: nil)
	}

	private let reuseIdentifier = "subtitleCell"
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath)-> UITableViewCell {
        var tableCell: UITableViewCell
        if let unwrappedTableCell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier) {
            tableCell = unwrappedTableCell as UITableViewCell
        } else {
			tableCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: reuseIdentifier)
		}

//		if let cell = tableCell {
        let cell = tableCell
        let repo = (fetchedResults as! RepositoriesViewModel).repoAtIndexPath(indexPath)

        cell.textLabel?.text = repo.name as? String
        let language = repo.language ?? ""
        cell.detailTextLabel?.text = language as NSString as String
        cell.imageView?.sd_setImageWithURL(NSURL(string: (repo.logo ?? "") as String), placeholderImage: UIImage(named: "repoPlaceholder"))
        cell.imageView?.layer.cornerRadius = 22
        cell.imageView?.clipsToBounds = true

        cell.textLabel?.font = UIFont(name: "Avenir Next", size: 14)
//		}

        return tableCell
    }

	/// Updates the viewModel based on the search term, then reloads the table view
	func updateSearchResultsForSearchController(searchController: UISearchController){
		self.viewModel().searchTerm = searchController.searchBar.text
		self.tableView.reloadData()
	}

}
