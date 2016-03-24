//
//  SettingsViewModel.swift
//  BlargBucket
//
//  Created by Luke Deniston on 1/18/15.
//  Copyright (c) 2015 Luke Deniston. All rights reserved.
//

import UIKit
import Locksmith
import MBProgressHUD

class SettingsViewModel {
   var sections: [[TableCellModel]] = []
   var sectionTitles = [LocalizedString("Loading Indicator")]

   var HUD: MBProgressHUD?

	init() {
		let firstSection = buildFirstSection()
		let secondSection = buildSecondSection()
		sections = [firstSection, secondSection]
	}

	func buildSecondSection() -> [TableCellModel] {
		return [
			TableCellModel(
				title: LocalizedString("Logout") as String,
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
				title: LocalizedString("Worms") as String,
				detailTitle: nil,
				imageView: nil,
				reuseIdentifier: NormalTableViewCell.reuseIdentifier(),
				action: { (view) in
					self.setHUD("worms", tableView: view as! UITableViewController)
				},
				accesoryType: BlargHUD.hudMode() == "worms" ? .Checkmark : .None
			),
			TableCellModel(
				title: LocalizedString("Tetris") as String,
				detailTitle: nil,
				imageView: nil,
				reuseIdentifier: NormalTableViewCell.reuseIdentifier(),
				action: { (view) in
					self.setHUD("tetris", tableView: view as! UITableViewController)
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
		self.HUD?.labelText = LocalizedString("Tap to dismiss") as String
		let tappy = UITapGestureRecognizer(target: self, action: #selector(SettingsViewModel.removeHUD))
		self.HUD?.addGestureRecognizer(tappy)
	}

	@objc func removeHUD() {
		HUD?.hide(true)
	}
}
