//
//  View-Extensions.swift
//  Places
//
//  Created by Michael Schembri on 2/5/19.
//  Copyright © 2019 Michael Schembri. All rights reserved.
//

import UIKit

extension UIStackView {

	@discardableResult
	func withMargins(_ margins: UIEdgeInsets) -> UIStackView {
		layoutMargins = margins
		isLayoutMarginsRelativeArrangement = true
		return self
	}

	@discardableResult
	func padLeft(_ left: CGFloat) -> UIStackView {
		isLayoutMarginsRelativeArrangement = true
		layoutMargins.left = left
		return self
	}

	@discardableResult
	func padTop(_ top: CGFloat) -> UIStackView {
		isLayoutMarginsRelativeArrangement = true
		layoutMargins.top = top
		return self
	}
}

extension UIView {

	@discardableResult
	func stack(_ axis: NSLayoutConstraint.Axis = .vertical, views: UIView..., spacing: CGFloat = 0) -> UIStackView {
		let stackView = UIStackView(arrangedSubviews: views)
		stackView.axis = axis
		stackView.spacing = spacing
		addSubview(stackView)
		stackView.fillSuperview()
		return stackView
	}

	func addSubviews(views: UIView...) {
		views.forEach { addSubview($0) }
	}
	
	func setupShadow(opacity: Float = 0, radius: CGFloat = 0, offset: CGSize = .zero, color: UIColor = .black) {
		layer.shadowOpacity = opacity
		layer.shadowRadius = radius
		layer.shadowOffset = offset
		layer.shadowColor = color.cgColor
	}

	convenience init(backgroundColor: UIColor = .clear) {
		self.init(frame: .zero)
		self.backgroundColor = backgroundColor
	}

}
