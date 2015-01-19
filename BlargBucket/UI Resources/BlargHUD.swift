//
//  BlargHUD.swift
//  BlargBucket
//
//  Created by Luke Deniston on 1/18/15.
//  Copyright (c) 2015 Luke Deniston. All rights reserved.
//

import UIKit

private var customHUDKey = "customHUDKey"
// TODO: Docs.
class BlargHUD: MBProgressHUD {
   class func customizedHUDAddedTo(view: UIView) -> MBProgressHUD {
		var HUD = MBProgressHUD.showHUDAddedTo(view, animated: true)
		HUD.mode = MBProgressHUDModeCustomView
		HUD.customView = UIImageView(image: UIImage.sd_animatedGIFNamed(BlargHUD.hudMode()))
		return HUD
   }

	class func setHudMode(mode:String) {
		NSUserDefaults.standardUserDefaults().setValue(mode, forKeyPath: customHUDKey)
	}

	class func hudMode() -> String {
		return NSUserDefaults.standardUserDefaults().valueForKey(customHUDKey) as? String ?? "tetris"
	}
}
