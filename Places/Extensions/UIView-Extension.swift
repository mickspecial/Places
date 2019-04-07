//
//  UIView-Extension.swift
//  Places
//
//  Created by Michael Schembri on 8/4/19.
//  Copyright © 2019 Michael Schembri. All rights reserved.
//

import UIKit

extension UIView {

	func anchor(top: NSLayoutYAxisAnchor?, leading: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, trailing: NSLayoutXAxisAnchor?, padding: UIEdgeInsets = .zero, size: CGSize = .zero) {

		translatesAutoresizingMaskIntoConstraints = false

		if let top = top {
			self.topAnchor.constraint(equalTo: top, constant: padding.top).isActive = true
		}

		if let leading = leading {
			self.leadingAnchor.constraint(equalTo: leading, constant: padding.left).isActive = true
		}

		if let bottom = bottom {
			self.bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom).isActive = true
		}

		if let trailing = trailing {
			self.trailingAnchor.constraint(equalTo: trailing, constant: -padding.right).isActive = true
		}

		if size.width != 0 {
			self.widthAnchor.constraint(equalToConstant: size.width).isActive = true
		}

		if size.height != 0 {
			self.heightAnchor.constraint(equalToConstant: size.height).isActive = true
		}

	}

	func fillSuperview(padding: UIEdgeInsets = .zero) {
		translatesAutoresizingMaskIntoConstraints = false
		if let superviewTopAnchor = superview?.topAnchor {
			topAnchor.constraint(equalTo: superviewTopAnchor, constant: padding.top).isActive = true
		}

		if let superviewBottomAnchor = superview?.bottomAnchor {
			bottomAnchor.constraint(equalTo: superviewBottomAnchor, constant: -padding.bottom).isActive = true
		}

		if let superviewLeadingAnchor = superview?.leadingAnchor {
			leadingAnchor.constraint(equalTo: superviewLeadingAnchor, constant: padding.left).isActive = true
		}

		if let superviewTrailingAnchor = superview?.trailingAnchor {
			trailingAnchor.constraint(equalTo: superviewTrailingAnchor, constant: -padding.right).isActive = true
		}
	}

	func centerInSuperview(size: CGSize) {
		translatesAutoresizingMaskIntoConstraints = false
		if let superviewCenterXAnchor = superview?.centerXAnchor {
			centerXAnchor.constraint(equalTo: superviewCenterXAnchor).isActive = true
		}

		if let superviewCenterYAnchor = superview?.centerYAnchor {
			centerYAnchor.constraint(equalTo: superviewCenterYAnchor).isActive = true
		}

		widthAnchor.constraint(equalToConstant: size.width).isActive = true
		heightAnchor.constraint(equalToConstant: size.height).isActive = true
	}

	func centerX() {
		translatesAutoresizingMaskIntoConstraints = false
		if let superviewCenterXAnchor = superview?.centerXAnchor {
			centerXAnchor.constraint(equalTo: superviewCenterXAnchor).isActive = true
		}
	}

	func centerY() {
		translatesAutoresizingMaskIntoConstraints = false
		if let superviewCenterYAnchor = superview?.centerYAnchor {
			centerYAnchor.constraint(equalTo: superviewCenterYAnchor).isActive = true
		}
	}

	func centerAbove(anchor: NSLayoutYAxisAnchor, withSpacing: CGFloat = 0) {
		self.centerX()
		self.anchor(top: nil, leading: nil, bottom: anchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: withSpacing, right: 0))
	}
}
