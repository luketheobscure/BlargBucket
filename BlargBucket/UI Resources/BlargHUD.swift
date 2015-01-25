//
//  BlargHUD.swift
//  BlargBucket
//
//  Created by Luke Deniston on 1/18/15.
//  Copyright (c) 2015 Luke Deniston. All rights reserved.
//

/// Key used for setting/retrieving the hud mode from standardUserDefaults
private var customHUDKey = "customHUDKey"

/**
	Use this class any time you need to show a loading indicator. Shows a fancy loading indicator with the custom view the user has selected.
	
	Don't use plain old MBProgressHUD!! Use this!!
	
	Example: `BlargHUD.customizedHUDAddedTo(self.view)`
*/
class BlargHUD: MBProgressHUD {

	/**
		The preferred method for showing a loading indicator on a view.
		
		:param: view The view to render the loading indicator over.
	*/
	class func customizedHUDAddedTo(view: UIView) -> MBProgressHUD {
		var HUD = MBProgressHUD.showHUDAddedTo(view, animated: true)
		HUD.mode = MBProgressHUDModeCustomView
		HUD.customView = UIImageView(image: UIImage.sd_animatedGIFNamed(BlargHUD.hudMode()))
		return HUD
	}

	/**
		Stores the standardUserDefaults value for our hud mode. Currently supports only "worms" or "tetris"
		
		:param: mode The value to be stored
	*/
	class func setHudMode(mode:String) {
		NSUserDefaults.standardUserDefaults().setValue(mode, forKeyPath: customHUDKey)
	}

	/// Retrieves the HUD mode from standardUserDefaults
	class func hudMode() -> String {
		return NSUserDefaults.standardUserDefaults().valueForKey(customHUDKey) as? String ?? "tetris"
	}
}
