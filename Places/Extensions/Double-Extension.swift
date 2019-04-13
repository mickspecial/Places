//
//  Double-Extension.swift
//  Places
//
//  Created by Michael Schembri on 13/4/19.
//  Copyright © 2019 Michael Schembri. All rights reserved.
//

import Foundation

extension Double {
	var twoDP: String {
		return String(format: "%.2f", self)
	}

	var oneDP: String {
		return String(format: "%.1f", self)
	}

	var noDP: String {
		return String(format: "%.0f", self)
	}
}
