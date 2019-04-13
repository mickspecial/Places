//
//  VC-Extension.swift
//  Places
//
//  Created by Michael Schembri on 13/4/19.
//  Copyright © 2019 Michael Schembri. All rights reserved.
//

import UIKit

@nonobjc extension UIViewController {
	func add(_ child: UIViewController, frame: CGRect? = nil) {
		addChild(child)

		if let frame = frame {
			child.view.frame = frame
		}

		view.addSubview(child.view)
		child.didMove(toParent: self)
	}

	func remove() {
		willMove(toParent: nil)
		view.removeFromSuperview()
		removeFromParent()
	}
}
