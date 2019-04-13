//
//  Place.swift
//  Places
//
//  Created by Michael Schembri on 8/4/19.
//  Copyright © 2019 Michael Schembri. All rights reserved.
//

import Foundation
import MapKit

enum MarkerColor: String, CaseIterable {
	case red, green, cyan, blue, white, orange, purple

	var markerImage: UIImage {
		return UIImage(named: self.rawValue)!
	}
}

class Place: NSObject {
	let name: String
	let address: String
	let lat: Double
	let long: Double
	let id: String
	let category: MarkerColor

	var markerImage: UIImage {
		return category.markerImage
	}

	init(name: String, address: String, lat: Double, long: Double, id: String, category: MarkerColor) {
		self.name = name
		self.address = address
		self.long = long
		self.lat = lat
		self.id = id
		self.category = category
	}

	init(mapItem: MKMapItem, name: String, category: MarkerColor) {
		self.name = name
		self.long = mapItem.placemark.coordinate.longitude
		self.lat = mapItem.placemark.coordinate.latitude
		self.id = UUID().uuidString
		self.category = category
		if mapItem.name == "Unknown Location" {
			self.address = ""
		} else {
			self.address = mapItem.name ?? ""
		}
	}

	init(currentLocation coordinate: CLLocationCoordinate2D) {
		let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate))
		self.name = "Current Location"
		self.long = mapItem.placemark.coordinate.longitude
		self.lat = mapItem.placemark.coordinate.latitude
		self.id = "current location"
		self.category = .white
		if mapItem.name == "Unknown Location" {
			self.address = ""
		} else {
			self.address = mapItem.name ?? ""
		}
	}
}

extension MKMapItem {

	func getStreetAddress() -> String {

		let geoCoder = CLGeocoder()
		let location = CLLocation(latitude: placemark.coordinate.latitude, longitude: placemark.coordinate.longitude)

		geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, _) -> Void in

			// Place details
			var placeMark: CLPlacemark!
			placeMark = placemarks?[0]

			// Location name
			if let locationName = placeMark.location {
				print(locationName)
			}
			// Street address
			if let street = placeMark.thoroughfare {
				print(street)
			}
			// City
			if let city = placeMark.subAdministrativeArea {
				print(city)
			}
			// Zip code
			if let zip = placeMark.isoCountryCode {
				print(zip)
			}
			// Country
			if let country = placeMark.country {
				print(country)
			}
		})

		return "TESTING"
	}
}

extension Place: MKAnnotation {
	var coordinate: CLLocationCoordinate2D {
		return CLLocationCoordinate2D(latitude: lat, longitude: long)
	}

	var placeMapItem: MKMapItem {
		let placeMapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate))
		placeMapItem.name = name
		return placeMapItem
	}
}
