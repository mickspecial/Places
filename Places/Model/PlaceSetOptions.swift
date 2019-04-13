//
//  PlaceSetOptions.swift
//  Places
//
//  Created by Michael Schembri on 13/4/19.
//  Copyright © 2019 Michael Schembri. All rights reserved.
//

import Foundation

enum PlaceSetOptions {
	case placeIsEmpty
	case matchesOtherPlace(newPlace: Place)
	case okToRoute(newPlace: Place)
	case missingOtherPlace(newPlace: Place)

	init(new: Place?, other: Place?) {
		if new == nil {
			self = .placeIsEmpty
			return
		}

		if let new = new, other == nil {
			self = .missingOtherPlace(newPlace: new)
			return
		}

		guard let new = new, let other = other else { fatalError() }

		if new.id == other.id {
			self = .matchesOtherPlace(newPlace: new)
			return
		}

		self = .okToRoute(newPlace: new)
	}
}
