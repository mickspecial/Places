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
	let address: String
	let lat: Double
	let long: Double
	let id: String
	let category: String

	init(name: String, details: String, lat: Double, long: Double, id: String, category: String) {
		self.name = name
		self.address = details
		self.long = long
		self.lat = lat
		self.id = id
		self.category = category
	}

	init(mapItem: MKMapItem, name: String, category: String) {
		self.name = name
		self.address = mapItem.name ?? "Unknown Location"
		self.long = mapItem.placemark.coordinate.longitude
		self.lat = mapItem.placemark.coordinate.latitude
		self.id = UUID().uuidString
		self.category = category
	}
}

extension Place: MKAnnotation {
	var coordinate: CLLocationCoordinate2D {
		return CLLocationCoordinate2D(latitude: lat, longitude: long)
	}
}
