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
		let timeInMinute = "  " + route.formattedTravelTime + "  "

		self.info = timeInMinute
		self.long = middle.coordinate.longitude
		self.lat = middle.coordinate.latitude
		self.route = route

		let label = UILabel()
		label.adjustsFontSizeToFitWidth = true
		label.backgroundColor = UIColor.FlatColor.Red.Cinnabar
		label.textColor = .white
		label.font = UIFont.boldSystemFont(ofSize: 14)
		label.frame = CGRect(x: 0, y: 0, width: 60, height: 22)
		label.layer.cornerRadius = 3
		label.layer.masksToBounds = true
		label.text = info

		annotationView.addSubview(label)
	}
}

extension RouteDetails: MKAnnotation {
	var coordinate: CLLocationCoordinate2D {
		return CLLocationCoordinate2D(latitude: lat, longitude: long)
	}
}
