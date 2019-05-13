//
//  UIView-Extension.swift
//  Places
//
//  Created by Michael Schembri on 8/4/19.
//  Copyright © 2019 Michael Schembri. All rights reserved.
//

import UIKit

// Reference Video: https://youtu.be/iqpAP7s3b-8
extension UIView {

	@discardableResult
	func anchor(top: NSLayoutYAxisAnchor?, leading: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, trailing: NSLayoutXAxisAnchor?, padding: UIEdgeInsets = .zero, size: CGSize = .zero) -> AnchoredConstraints {

		translatesAutoresizingMaskIntoConstraints = false
		var anchoredConstraints = AnchoredConstraints()

		if let top = top {
			anchoredConstraints.top = topAnchor.constraint(equalTo: top, constant: padding.top)
		}

		if let leading = leading {
			anchoredConstraints.leading = leadingAnchor.constraint(equalTo: leading, constant: padding.left)
		}

		if let bottom = bottom {
			anchoredConstraints.bottom = bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom)
		}

		if let trailing = trailing {
			anchoredConstraints.trailing = trailingAnchor.constraint(equalTo: trailing, constant: -padding.right)
		}

		if size.width != 0 {
			anchoredConstraints.width = widthAnchor.constraint(equalToConstant: size.width)
		}

		if size.height != 0 {
			anchoredConstraints.height = heightAnchor.constraint(equalToConstant: size.height)
		}

		[anchoredConstraints.top, anchoredConstraints.leading, anchoredConstraints.bottom, anchoredConstraints.trailing, anchoredConstraints.width, anchoredConstraints.height].forEach { $0?.isActive = true }

		return anchoredConstraints
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

	func centerInSuperview(size: CGSize = .zero) {
		translatesAutoresizingMaskIntoConstraints = false
		if let superviewCenterXAnchor = superview?.centerXAnchor {
			centerXAnchor.constraint(equalTo: superviewCenterXAnchor).isActive = true
		}

		if let superviewCenterYAnchor = superview?.centerYAnchor {
			centerYAnchor.constraint(equalTo: superviewCenterYAnchor).isActive = true
		}

		if size.width != 0 {
			widthAnchor.constraint(equalToConstant: size.width).isActive = true
		}

		if size.height != 0 {
			heightAnchor.constraint(equalToConstant: size.height).isActive = true
		}
	}

	func centerXInSuperview() {
		translatesAutoresizingMaskIntoConstraints = false
		if let superViewCenterXAnchor = superview?.centerXAnchor {
			centerXAnchor.constraint(equalTo: superViewCenterXAnchor).isActive = true
		}
	}

	func centerYInSuperview() {
		translatesAutoresizingMaskIntoConstraints = false
		if let centerY = superview?.centerYAnchor {
			centerYAnchor.constraint(equalTo: centerY).isActive = true
		}
	}

	func constrainWidth(constant: CGFloat) {
		translatesAutoresizingMaskIntoConstraints = false
		widthAnchor.constraint(equalToConstant: constant).isActive = true
	}

	func constrainHeight(constant: CGFloat) {
		translatesAutoresizingMaskIntoConstraints = false
		heightAnchor.constraint(equalToConstant: constant).isActive = true
	}
}

struct AnchoredConstraints {
	var top, leading, bottom, trailing, width, height: NSLayoutConstraint?
}

extension UIStackView {

	@discardableResult
	open func withMargins(_ margins: UIEdgeInsets) -> UIStackView {
		layoutMargins = margins
		isLayoutMarginsRelativeArrangement = true
		return self
	}

	@discardableResult
	open func padLeft(_ left: CGFloat) -> UIStackView {
		isLayoutMarginsRelativeArrangement = true
		layoutMargins.left = left
		return self
	}

	@discardableResult
	open func padTop(_ top: CGFloat) -> UIStackView {
		isLayoutMarginsRelativeArrangement = true
		layoutMargins.top = top
		return self
	}

	@discardableResult
	open func padBottom(_ bottom: CGFloat) -> UIStackView {
		isLayoutMarginsRelativeArrangement = true
		layoutMargins.bottom = bottom
		return self
	}

	@discardableResult
	open func padRight(_ right: CGFloat) -> UIStackView {
		isLayoutMarginsRelativeArrangement = true
		layoutMargins.right = right
		return self
	}
}

extension UIView {

	fileprivate func _stack(_ axis: NSLayoutConstraint.Axis = .vertical, views: [UIView], spacing: CGFloat = 0, alignment: UIStackView.Alignment = .fill) -> UIStackView {
		let stackView = UIStackView(arrangedSubviews: views)
		stackView.axis = axis
		stackView.spacing = spacing
		stackView.alignment = alignment
		addSubview(stackView)
		stackView.fillSuperview()
		return stackView
	}

	@discardableResult
	open func stack(_ views: UIView..., spacing: CGFloat = 0, alignment: UIStackView.Alignment = .fill) -> UIStackView {
		return _stack(.vertical, views: views, spacing: spacing, alignment: alignment)
	}

	@discardableResult
	open func hstack(_ views: UIView..., spacing: CGFloat = 0, alignment: UIStackView.Alignment = .fill) -> UIStackView {
		return _stack(.horizontal, views: views, spacing: spacing, alignment: alignment)
	}

	@discardableResult
	open func withSize<T: UIView>(_ size: CGSize) -> T {
		translatesAutoresizingMaskIntoConstraints = false
		widthAnchor.constraint(equalToConstant: size.width).isActive = true
		heightAnchor.constraint(equalToConstant: size.height).isActive = true
		return self as! T
	}

	@discardableResult
	open func withHeight(_ height: CGFloat) -> UIView {
		translatesAutoresizingMaskIntoConstraints = false
		heightAnchor.constraint(equalToConstant: height).isActive = true
		return self
	}

	@discardableResult
	open func withWidth(_ width: CGFloat) -> UIView {
		translatesAutoresizingMaskIntoConstraints = false
		widthAnchor.constraint(equalToConstant: width).isActive = true
		return self
	}

	@discardableResult
	func withBorder(width: CGFloat, color: UIColor) -> UIView {
		layer.borderWidth = width
		layer.borderColor = color.cgColor
		return self
	}

	// my method
	func addSubviews(_ views: UIView...) {
		views.forEach { addSubview($0) }
	}
}

extension UIEdgeInsets {
	static public func allSides(side: CGFloat) -> UIEdgeInsets {
		return .init(top: side, left: side, bottom: side, right: side)
	}
}

extension UIImageView {
	convenience public init(image: UIImage?, contentMode: UIView.ContentMode = .scaleAspectFill) {
		self.init(image: image)
		self.contentMode = contentMode
		self.clipsToBounds = true
	}
}
