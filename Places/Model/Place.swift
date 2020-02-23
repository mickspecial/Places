//
//  Place.swift
//  Places
//
//  Created by Michael Schembri on 8/4/19.
//  Copyright © 2019 Michael Schembri. All rights reserved.
//

import Foundation
import MapKit

struct UserMarker {
	let color: MarkerColor
	let customText: String
}

enum MarkerColor: String, CaseIterable, Codable {
	case red, green, cyan, blue, white, orange, purple

	var markerImage: UIImage {
		return UIImage(named: self.rawValue)!
	}

	static func sortedUserMarkers(userData: [MarkerColor: String]) -> [UserMarker] {

		let pickerData = userData.map { (key: MarkerColor, value: String) in
			return UserMarker(color: key, customText: value)
		}

		return pickerData.sorted(by: { $0.customText < $1.customText })
	}

	static func sortedUserMarkersList(userData: [MarkerColor: String]) -> [String] {

		let data = MarkerColor.sortedUserMarkers(userData: userData)

		return data.map({ $0.customText })
	}

	static func customNameForMarker(userData: [MarkerColor: String], markerColor: MarkerColor) -> String {

		let data = MarkerColor.sortedUserMarkers(userData: userData)

		let r = data.first(where: { $0.color == markerColor })

		return r?.customText ?? ""
	}

	static func indexForMarker(userData: [MarkerColor: String], markerColor: MarkerColor) -> Int {

		let data = MarkerColor.sortedUserMarkers(userData: userData)

		let r = data.firstIndex(where: { $0.color == markerColor })

		return r ?? 0
	}
}

class Place: NSObject, Codable {
	let name: String
	let address: String
	let lat: Double
	let long: Double
	let id: String
	let category: MarkerColor
	let isDeleted: Bool

	var markerImage: UIImage {
		return category.markerImage
	}

	init(name: String, address: String, lat: Double, long: Double, id: String, category: MarkerColor, isDeleted: Bool) {
		self.name = name
		self.address = address
		self.long = long
		self.lat = lat
		self.id = id
		self.category = category
		self.isDeleted = isDeleted
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
		self.isDeleted = false
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
		self.isDeleted = false
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

		return "? Street Address"
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

extension Place {

	static func importData(from url: URL) {

		let needTo = url.startAccessingSecurityScopedResource()
		// https://littlebitesofcocoa.com/321-opening-files-from-the-files-app
		// https://www.infragistics.com/community/blogs/b/stevez/posts/ios-tips-and-tricks-associate-a-file-type-with-your-app-part-2

		guard let data = try? Data(contentsOf: url) else {
			SCLAlertView(appearance: AlertService.standard).showError("Import Error")
			return
		}

		let decoder = JSONDecoder()
		decoder.dateDecodingStrategy = .iso8601

		if let decodedUser = try? decoder.decode(User.self, from: data) {
			User.current = decodedUser
			User.current.save()
		} else {
			SCLAlertView(appearance: AlertService.standard).showError("Import Error")
		}

		if needTo {
			url.stopAccessingSecurityScopedResource()
		}
	}
}
