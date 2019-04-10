//
//  PlacesController.swift
//  Places
//
//  Created by Michael Schembri on 8/4/19.
//  Copyright © 2019 Michael Schembri. All rights reserved.
//

import Foundation

class PlacesController {

	private (set) var places = [Place]()

	init(places: [Place] = [Place]()) {
		self.places = places
		addTestData()
	}

	func addTestData() {
		// test places
		let testPlaces = [
			Place(name: "Josh", details: "1 Demo St", lat: -28.0051447, long: 153.3507475, id: "1", category: .cyan),
			Place(name: "Harry", details: "2 Cat Rd", lat: -27.955567312387117, long: 153.3850246667862, id: "2", category: .red),
			Place(name: "Marry", details: "111 Smith Road", lat: -28.0968254, long: 153.443296, id: "3", category: .orange)
		]

		places.append(contentsOf: testPlaces)
	}

	func addPlace(_ place: Place) {
		places.append(place)
		print("Place was added to controller")
	}

	func removePlace(_ place: Place) {
		places.removeAll(where: { place.id == $0.id })
	}
}

class CategoryController {

	var categories: [MarkerColor: String]

	init(categories: [MarkerColor: String] = [MarkerColor: String]()) {
		self.categories = categories
		addTestData()
	}

	func addTestData() {
		// test places

		let test = [
			MarkerColor.blue: "Blue Marker",
			MarkerColor.red: "Red Marker",
			MarkerColor.orange: "Orange Marker",
			MarkerColor.cyan: "Cyan Marker",
			MarkerColor.white: "White Marker",
			MarkerColor.purple: "Purple Marker",
			MarkerColor.green: "Green Marker"
		]

		self.categories = test
	}
}
