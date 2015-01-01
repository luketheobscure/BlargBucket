//
//  MainTabBarViewController.swift
//  BlargBucket
//
//  Created by Luke Deniston on 8/16/14.
//  Copyright (c) 2014 Luke Deniston. All rights reserved.
//

import UIKit

/// The main tab bar that's used everywhere
class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

		let info = RepositoryInfoViewController(style: .Grouped)
		info.tabBarItem = UITabBarItem(title: "Overview", image: UIImage(named: "info"), selectedImage: UIImage(named: "infoFilled"))

		let pullRequests = PullRequestsController()
		pullRequests.tabBarItem = UITabBarItem(title: "Pull Requests", image: UIImage(named: "pullRequest"), selectedImage: UIImage(named: "pullRequestFilled"))

		let events = EventsViewController()
		events.tabBarItem = UITabBarItem(title: "Events", image: UIImage(named: "feed"), selectedImage: UIImage(named: "feedFilled"))

		let settings = SettingsTableViewController()
		settings.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(named: "settings"), selectedImage: UIImage(named: "settingsFilled"))

		viewControllers = [
			BlargNav(rootViewController:info),
			BlargNav(rootViewController:pullRequests),
			BlargNav(rootViewController:events),
			BlargNav(rootViewController:settings)
		]
    }

}
