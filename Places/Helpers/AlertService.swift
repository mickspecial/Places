//
//  AlertService.swift
//  Places
//
//  Created by Michael Schembri on 10/4/19.
//  Copyright © 2019 Michael Schembri. All rights reserved.
//

import UIKit

class AlertService {
	private init() {}

	static var standard: SCLAlertView.SCLAppearance {
		let appearance = SCLAlertView.SCLAppearance(
			kButtonHeight: 40,
			kTitleFont: UIFont.systemFont(ofSize: 18, weight: .regular),
			kButtonFont: UIFont.systemFont(ofSize: 18, weight: .semibold)
		)
		return appearance
	}

	static var standardNoCloseButton: SCLAlertView.SCLAppearance {
		let appearance = SCLAlertView.SCLAppearance(
			kButtonHeight: 40,
			kTitleFont: UIFont.systemFont(ofSize: 18, weight: .regular),
			kButtonFont: UIFont.systemFont(ofSize: 18, weight: .semibold),
			showCloseButton: false,
			buttonsLayout: SCLAlertButtonLayout.vertical
		)
		return appearance
	}
}
