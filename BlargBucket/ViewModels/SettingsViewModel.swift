//
//  SettingsViewModel.swift
//  BlargBucket
//
//  Created by Luke Deniston on 1/18/15.
//  Copyright (c) 2015 Luke Deniston. All rights reserved.
//

import UIKit

class SettingsViewModel {
   var sections: [[TableCellModel]] = []
   var sectionTitles = [LocalizedString("Loading Indicator")]

   var HUD: MBProgressHUD?

	init() {
		var firstSection = buildFirstSection()
		var secondSection = buildSecondSection()
		sections = [firstSection, secondSection]
	}

	func buildSecondSection() -> [TableCellModel] {
		return [
			TableCellModel(
				title: LocalizedString("Logout"),
				detailTitle: nil,
				imageView: nil,
				reuseIdentifier: ButtonTableViewCell.reuseIdentifier(),
				action: { (view) in
					DataFetcher.clearAuthToken()
					Locksmith.clearAuthToken()
					User.clearCurrentUser()
					AppDelegate.sharedInstance().window?.rootViewController = LoginViewController()
				}
			)
		]
	}

	func buildFirstSection() -> [TableCellModel] {
		return [
			TableCellModel(
				title: LocalizedString("Worms"),
				detailTitle: nil,
				imageView: nil,
				reuseIdentifier: NormalTableViewCell.reuseIdentifier(),
				action: { (view) in
					self.setHUD("worms", tableView: view as UITableViewController)
				},
				accesoryType: BlargHUD.hudMode() == "worms" ? .Checkmark : .None
			),
			TableCellModel(
				title: LocalizedString("Tetris"),
				detailTitle: nil,
				imageView: nil,
				reuseIdentifier: NormalTableViewCell.reuseIdentifier(),
				action: { (view) in
					self.setHUD("tetris", tableView: view as UITableViewController)
				},
				accesoryType: BlargHUD.hudMode() == "tetris" ? .Checkmark : .None

			)
		]
	}

	func setHUD(mode:String, tableView:UITableViewController){
		BlargHUD.setHudMode(mode)
		showHUD(tableView.view)
		sections = [self.buildFirstSection() ,self.buildSecondSection()]
		tableView.tableView.reloadData()
	}

	func showHUD(view:UIView) {
		self.HUD = BlargHUD.customizedHUDAddedTo(view)
		self.HUD?.labelText = LocalizedString("Tap to dismiss")
		var tappy = UITapGestureRecognizer(target: self, action: "removeHUD")
		self.HUD?.addGestureRecognizer(tappy)
	}

	@objc func removeHUD() {
		HUD?.hide(true)
	}
}
