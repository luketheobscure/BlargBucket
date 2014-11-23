//
//  UIButtonExtension.swift
//  BlargBucket
//
//  Created by Luke Deniston on 8/13/14.
//  Copyright (c) 2014 Luke Deniston. All rights reserved.
//

import UIKit
import QuartzCore

extension UIButton {
	func createShadow(color:UIColor, radius: CGFloat){
		let backGroundColor = CALayer()
		backGroundColor.backgroundColor = layer.backgroundColor
		backGroundColor.cornerRadius = radius
		backGroundColor.frame = CGRectMake(0, 0, CGRectGetWidth(layer.frame), CGRectGetHeight(layer.frame));
		layer.insertSublayer(backGroundColor, atIndex:0)

		let bottomShadow = CALayer()
		bottomShadow.backgroundColor = color.CGColor
		bottomShadow.cornerRadius = radius
		bottomShadow.frame = CGRectMake(0, 4, CGRectGetWidth(layer.frame), CGRectGetHeight(layer.frame));
		layer.insertSublayer(bottomShadow, atIndex:0)
	}
}