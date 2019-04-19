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
}
