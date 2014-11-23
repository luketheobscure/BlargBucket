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
}
