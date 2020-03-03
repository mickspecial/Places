//
//  RouteDetails.swift
//  Places
//
//  Created by Michael Schembri on 13/4/19.
//  Copyright © 2019 Michael Schembri. All rights reserved.
//

import Foundation
import MapKit

class RouteDetails: NSObject {

	let lat: Double
	let long: Double
	let info: String
	let route: MKRoute
	let annotationView = MKAnnotationView()

	init(route: MKRoute) {

		let polyline = route.polyline
		let middle = polyline.points()[polyline.pointCount / 2]
		let timeInMinute = route.formattedTravelTime

		self.info = timeInMinute
		self.long = middle.coordinate.longitude
		self.lat = middle.coordinate.latitude
		self.route = route

		let label = UILabel()
		label.adjustsFontSizeToFitWidth = true
		label.backgroundColor = UIColor.FlatColor.Red.Cinnabar
		label.textColor = .white
		label.textAlignment = .center
		label.font = UIFont.boldSystemFont(ofSize: 14)
		label.frame = CGRect(x: 0, y: 0, width: 64, height: 24)
		label.layer.cornerRadius = 3
		label.layer.masksToBounds = true
		label.text = info
		annotationView.addSubview(label)
		label.centerInSuperview(size: CGSize(width: 64, height: 24))
	}
}

extension RouteDetails: MKAnnotation {
	var coordinate: CLLocationCoordinate2D {
		return CLLocationCoordinate2D(latitude: lat, longitude: long)
	}
}

class PolyLabel: NSObject {

	let lat: Double
	let long: Double
	let info: String
	let showArea: Double
	let annotationView = MKAnnotationView()

	let kilometers: Double

	init(lat: Double, long: Double, info: String, showArea: Double) {

		let timeInMinute = String(showArea)

		self.info = timeInMinute
		self.long = long
		self.lat = lat
		self.showArea = showArea
		self.kilometers = showArea / 1000000

		let label = UILabel()
		label.adjustsFontSizeToFitWidth = true
		label.backgroundColor = UIColor.FlatColor.Red.Cinnabar
		label.textColor = .white
		label.textAlignment = .center
		label.font = UIFont.boldSystemFont(ofSize: 14)
		label.frame = CGRect(x: 0, y: 0, width: 64, height: 24)
		label.layer.cornerRadius = 3
		label.layer.masksToBounds = true
		label.text = String(format: "%.2f", kilometers) + " km²"
		annotationView.addSubview(label)
		label.centerInSuperview(size: CGSize(width: 64, height: 24))
	}
}

extension PolyLabel: MKAnnotation {
	var coordinate: CLLocationCoordinate2D {
		return CLLocationCoordinate2D(latitude: lat, longitude: long)
	}
}

class PolyMarker: NSObject, MKAnnotation {

	let coordinate: CLLocationCoordinate2D
	//let annotationView = MKAnnotationView()

	var markerImage: UIImage {
		return MarkerColor.white.markerImage
	}

	init(coordinate: CLLocationCoordinate2D) {
		self.coordinate = coordinate
	}
}
