//
//  UILabel-Extension.swift
//  Places
//
//  Created by Michael Schembri on 20/4/19.
//  Copyright © 2019 Michael Schembri. All rights reserved.
//

import UIKit

extension UILabel {
	convenience init(text: String, font: UIFont, textColor: UIColor = .black) {
		self.init(frame: .zero)
		self.text = text
		self.font = font
		self.textColor = textColor
	}

	convenience init(text: String, font: UIFont? = UIFont.systemFont(ofSize: 14), textColor: UIColor = .black, textAlignment: NSTextAlignment = .left, numberOfLines: Int = 1) {
		self.init()
		self.text = text
		self.font = font
		self.textColor = textColor
		self.textAlignment = textAlignment
		self.numberOfLines = numberOfLines
	}
}

extension UIButton {

	convenience public init(title: String, titleColor: UIColor, font: UIFont = .systemFont(ofSize: 16), backgroundColor: UIColor = .clear, target: Any? = nil, action: Selector? = nil) {
		self.init(type: .system)
		setTitle(title, for: .normal)
		setTitleColor(titleColor, for: .normal)
		self.titleLabel?.font = font

		self.backgroundColor = backgroundColor
		if let action = action {
			addTarget(target, action: action, for: .touchUpInside)
		}
	}

	convenience public init(image: UIImage, tintColor: UIColor? = nil) {
		self.init(type: .system)
		if tintColor == nil {
			setImage(image, for: .normal)
		} else {
			setImage(image.withRenderingMode(.alwaysTemplate), for: .normal)
			self.tintColor = tintColor
		}

	}
}
