//
//  Map-Extensions.swift
//  Places
//
//  Created by Michael Schembri on 13/4/19.
//  Copyright © 2019 Michael Schembri. All rights reserved.
//

import Foundation
import MapKit

extension MKRoute {
	var kilometers: String {
		return (distance / 1000).twoDP
	}

	var formattedTravelTime: String {
		// https://developer.apple.com/documentation/foundation/datecomponentsformatter/unitsstyle
		let formatter = DateComponentsFormatter()
		formatter.allowedUnits = [.hour, .minute]
		formatter.unitsStyle = .short
		let formattedString = formatter.string(from: expectedTravelTime)
		return formattedString ?? ""
	}
}

extension CLLocationCoordinate2D {
	func isEqual(_ coord: CLLocationCoordinate2D) -> Bool {
		return (fabs(self.latitude - coord.latitude) < .ulpOfOne) && (fabs(self.longitude - coord.longitude) < .ulpOfOne)
	}
}
