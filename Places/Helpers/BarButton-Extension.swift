//
//  BarButton-Extension.swift
//  Places
//
//  Created by Michael Schembri on 12/4/19.
//  Copyright © 2019 Michael Schembri. All rights reserved.
//

import UIKit

extension UIBarButtonItem {

	enum BarButtonSize: CGFloat {
		case xsmall = 20
		case small = 22
		case medium = 24
		case large = 28
		case xlarge = 36
	}

	// image resize only works with png images not svg / pdf

	// If want to tint = tint the customView property
	// editBtn.customView?.tintColor = userIsEditing ? Theme.red : Theme.navBarTint

	static func menuButton(_ target: Any?, action: Selector, imageName: String, size: BarButtonSize = .medium) -> UIBarButtonItem {
		let button = UIButton(type: .system)
		button.setImage(UIImage(named: imageName), for: .normal)
		button.addTarget(target, action: action, for: .touchUpInside)

		let menuBarItem = UIBarButtonItem(customView: button)
		menuBarItem.customView?.translatesAutoresizingMaskIntoConstraints = false
		menuBarItem.customView?.heightAnchor.constraint(equalToConstant: size.rawValue).isActive = true
		menuBarItem.customView?.widthAnchor.constraint(equalToConstant: size.rawValue).isActive = true

		return menuBarItem
	}
}
