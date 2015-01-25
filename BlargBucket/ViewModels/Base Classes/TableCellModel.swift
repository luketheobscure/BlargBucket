//
//  TableCellModel.swift
//  BlargBucket
//
//  Created by Luke Deniston on 11/7/14.
//  Copyright (c) 2014 Luke Deniston. All rights reserved.
//

import Foundation

struct TableCellModel {
	var title: String?
	var detailTitle: String?
	var imageView: UIImageView?
	var reuseIdentifier: String = "reuseIdentifer"
	var action: ((view:UIViewController) -> ())?
	var accesoryType: UITableViewCellAccessoryType = .None

	// Convenience init, so we can add properties to the struct without editing exisitng code.
	init(title: String?, detailTitle: String?, imageView: UIImageView?, reuseIdentifier: String = "reuseIdentifer", action: ((view:UIViewController) -> ())?){
		self.title = title
		self.detailTitle = detailTitle
		self.imageView = imageView
		self.reuseIdentifier = reuseIdentifier
		self.action = action
	}

	init(title: String?, detailTitle: String?, imageView: UIImageView?, reuseIdentifier: String = "reuseIdentifer", action: ((view:UIViewController) -> ())?, accesoryType: UITableViewCellAccessoryType){
		self = TableCellModel(title: title
		, detailTitle: detailTitle, imageView: imageView, reuseIdentifier: reuseIdentifier, action: action)
		self.accesoryType = accesoryType
	}
}
