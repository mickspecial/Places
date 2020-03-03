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
		print("\(expectedTravelTime)")
		if expectedTravelTime >= 3600 {
			// over 1 hr
			formatter.unitsStyle = .abbreviated
		} else {
			// “9 hr, 41 min, 30 sec”
			formatter.unitsStyle = .short
		}
		let formattedString = formatter.string(from: expectedTravelTime)
		return formattedString ?? ""
	}
}

extension CLLocationCoordinate2D {
	func isEqual(_ coord: CLLocationCoordinate2D) -> Bool {
		return (fabs(self.latitude - coord.latitude) < .ulpOfOne) && (fabs(self.longitude - coord.longitude) < .ulpOfOne)
	}
}

extension Array where Element == CLLocationCoordinate2D {

	func regionArea() -> Double {
		// in square km 6_378.137
		// in sq m 6_378_137

		func radians(degrees: Double) -> Double {
			return degrees * .pi / 180
		}

		let kEarthRadius = 6_378_137.0

		guard self.count > 2 else { return 0 }
		var area = 0.0

		for i in 0..<self.count {
			let p1 = self[i > 0 ? i - 1 : self.count - 1]
			let p2 = self[i]

			area += radians(degrees: p2.longitude - p1.longitude) * (2 + sin(radians(degrees: p1.latitude)) + sin(radians(degrees: p2.latitude)) )
		}
		area = -(area * kEarthRadius * kEarthRadius / 2)

		return Swift.max(area, -area) // In order not to worry about is polygon clockwise or counterclockwise defined.
	}

	func sortConvex() -> [CLLocationCoordinate2D] {

		// X = longitude
		// Y = latitude

		// 2D cross product of OA and OB vectors, i.e. z-component of their 3D cross product.
		// Returns a positive value, if OAB makes a counter-clockwise turn,
		// negative for clockwise turn, and zero if the points are collinear.
		func cross(P: CLLocationCoordinate2D, _ A: CLLocationCoordinate2D, _ B: CLLocationCoordinate2D) -> Double {
			let part1 = (A.longitude - P.longitude) * (B.latitude - P.latitude)
			let part2 = (A.latitude - P.latitude) * (B.longitude - P.longitude)
			return part1 - part2
		}

		// Sort points lexicographically
		let points = self.sorted(by: {
			$0.longitude == $1.longitude ? $0.latitude < $1.latitude : $0.longitude < $1.longitude
		})

		// Build the lower hull
		var lower: [CLLocationCoordinate2D] = []
		for p in points {
			while lower.count >= 2 && cross(P: lower[lower.count-2], lower[lower.count-1], p) <= 0 {
				lower.removeLast()
			}
			lower.append(p)
		}

		// Build upper hull
		var upper: [CLLocationCoordinate2D] = []
		for p in points.reversed() {
			while upper.count >= 2 && cross(P: upper[upper.count-2], upper[upper.count-1], p) <= 0 {
				upper.removeLast()
			}
			upper.append(p)
		}

		// Last point of upper list is omitted because it is repeated at the
		// beginning of the lower list.
		upper.removeLast()

		// Concatenation of the lower and upper hulls gives the convex hull.
		return (upper + lower)
	}
}

class PolygonAnnotation: NSObject, MKAnnotation {

	init(coordinate: CLLocationCoordinate2D) {
		self.coordinate = coordinate
        super.init()
    }

	var markerImage: UIImage {
		return MarkerColor.white.markerImage
	}

    var coordinate: CLLocationCoordinate2D
}
