//
//  HomeCoordinator.swift
//  Places
//
//  Created by Michael Schembri on 8/4/19.
//  Copyright © 2019 Michael Schembri. All rights reserved.
//

import UIKit

class HomeCoordinator: Coordinator {

	var childCoordinators = [Coordinator]()
	var navigationController: UINavigationController
	var placesCtrl: PlacesController

	init(navigationController: UINavigationController = UINavigationController(), placesCtrl: PlacesController) {
		self.navigationController = navigationController
		self.placesCtrl = placesCtrl

		let home = HomeViewController(placesCtrl: placesCtrl, coordinator: self)
		home.tabBarItem = UITabBarItem(title: "Places", image: #imageLiteral(resourceName: "list"), tag: 0)
		navigationController.viewControllers = [home]
	}

	func showDetails(_ place: Place) {
		let test = HomeDetailsViewController(coordinator: self, place: place)
		navigationController.pushViewController(test, animated: true)
	}

	func deletePlace(_ place: Place) {
		print("Delete - \(place.name)")
		placesCtrl.removePlace(place)
		navigationController.popViewController(animated: true)
	}

	func updatePlace(_ place: Place, name: String) {
		if name == place.name || name.isEmpty {
			return
		}

		print("Update - \(place.name)")
		let newPlace = Place(name: name, details: place.address, lat: place.lat, long: place.long, id: place.id)
		placesCtrl.removePlace(place)
		placesCtrl.addPlace(newPlace)
	}

	func start() {

	}
}
