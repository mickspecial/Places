//
//  SCLExtensions.swift
//  studiotrackr
//
//  Created by Michael Schembri on 9/1/19.
//  Copyright © 2019 Michael Schembri. All rights reserved.
//

import UIKit

extension Int {
	
	func toUIColor() -> UIColor {
		return UIColor(
			red: CGFloat((self & 0xFF0000) >> 16) / 255.0,
			green: CGFloat((self & 0x00FF00) >> 8) / 255.0,
			blue: CGFloat(self & 0x0000FF) / 255.0,
			alpha: CGFloat(1.0)
		)
	}
	
	func toCGColor() -> CGColor {
		return self.toUIColor().cgColor
	}
}

extension UInt {
	
	func toUIColor() -> UIColor {
		return UIColor(
			red: CGFloat((self & 0xFF0000) >> 16) / 255.0,
			green: CGFloat((self & 0x00FF00) >> 8) / 255.0,
			blue: CGFloat(self & 0x0000FF) / 255.0,
			alpha: CGFloat(1.0)
		)
	}
	
	func toCGColor() -> CGColor {
		return self.toUIColor().cgColor
	}
}

extension String {
	
	func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
		let constraintRect = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
		
		let boundingBox = self.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
		
		return boundingBox.height
	}
	
}
