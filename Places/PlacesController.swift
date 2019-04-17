//
//  PlacesController.swift
//  Places
//
//  Created by Michael Schembri on 8/4/19.
//  Copyright © 2019 Michael Schembri. All rights reserved.
//

import Foundation

class PlacesController {

//	private (set) var places: [Place] {
//		didSet {
//			// update the user
//			User.current.places = places
//			save()
//		}
//	}

	init(places: [Place]) {
		print("SET ???")
		//self.places = User.current.places
	}

//	private func save() {
//		DispatchQueue.main.async {
//			User.current.save()
//		}
//	}

//	func addTestData() {
//		let testPlaces = [
//			Place(name: "Harry", address: "2 Cat Rd", lat: -27.955567312387117, long: 153.3850246667862, id: "2", category: .red),
//			Place(name: "Marry", address: "111 Smith Road", lat: -28.0968254, long: 153.443296, id: "3", category: .orange)
//		]
//
//		places.append(contentsOf: testPlaces)
//	}

//	func addPlace(_ place: Place) {
//		places.append(place)
//		print("Place was added to controller")
//	}
//
//	func removePlace(_ place: Place) {
//		places.removeAll(where: { place.id == $0.id })
//	}
}

class CategoryController {

//	var categories: [MarkerColor: String] {
//		didSet {
//			print("Save categories")
//			User.current.categories = categories
//			save()
//		}
//	}

//	private func save() {
//		DispatchQueue.main.async {
//			User.current.save()
//		}
//	}

	init(categories: [MarkerColor: String]) {
		//self.categories = categories
	}
}
