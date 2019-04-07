//
//  Place.swift
//  Places
//
//  Created by Michael Schembri on 8/4/19.
//  Copyright © 2019 Michael Schembri. All rights reserved.
//

import Foundation
import MapKit

class Place: NSObject {
	let name: String
	let details: String
	let lat: Double
	let long: Double
	let id: String

	init(name: String, details: String, lat: Double, long: Double, id: String) {
		self.name = name
		self.details = details
		self.long = long
		self.lat = lat
		self.id = id
	}
}

extension Place: MKAnnotation {
	var coordinate: CLLocationCoordinate2D {
		return CLLocationCoordinate2D(latitude: lat, longitude: long)
	}
}
