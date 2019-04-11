//
//  String-Extension.swift
//  Places
//
//  Created by Michael Schembri on 7/4/19.
//  Copyright © 2019 Michael Schembri. All rights reserved.
//

import UIKit

/**
Highlights the matching search strings with the results
- parameter text: The text to highlight
- parameter ranges: The ranges where the text should be highlighted
- parameter size: The size the text should be set at
- returns: A highlighted attributed string with the ranges highlighted
*/

extension NSAttributedString {
	static func highlightedText(_ text: String, ranges: [NSValue], size: CGFloat) -> NSAttributedString {
		let attributedText = NSMutableAttributedString(string: text)
		let regular = UIFont.systemFont(ofSize: size)
		let range = NSRange(location: 0, length: text.count)
		attributedText.addAttribute(NSAttributedString.Key.font, value: regular, range: range)
		let bold = UIFont.boldSystemFont(ofSize: size)
		for value in ranges {
			attributedText.addAttribute(NSAttributedString.Key.font, value: bold, range: value.rangeValue)
			attributedText.addAttribute(NSAttributedString.Key.foregroundColor, value: Theme.current.highlight, range: value.rangeValue)
		}
		return attributedText
	}
}

extension UITextField {
	var string: String { return text ?? "" }
}
