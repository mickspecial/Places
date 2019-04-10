//
//  MapSearchCoordinator.swift
//  Places
//
//  Created by Michael Schembri on 10/4/19.
//  Copyright © 2019 Michael Schembri. All rights reserved.
//

import UIKit
import MapKit

class FindCoordinator: Coordinator {

	var childCoordinators = [Coordinator]()
	var navigationController: UINavigationController
	var placesCtrl: PlacesController
	var categoriesCtrl: CategoryController

	init(navigationController: UINavigationController = UINavigationController(), placesCtrl: PlacesController, categoriesCtrl: CategoryController) {
		self.navigationController = navigationController
		self.placesCtrl = placesCtrl
		self.categoriesCtrl = categoriesCtrl

		let findVC = FindTableViewController(placesCtrl: placesCtrl, coordinator: self)
		findVC.tabBarItem = UITabBarItem(title: "Find", image: #imageLiteral(resourceName: "find"), tag: 2)
		navigationController.viewControllers = [findVC]
	}

	func showDetails(_ item: MKMapItem) {
		let detailsVC = FindDetailsViewController(coordinator: self, item: item, categoriesController: categoriesCtrl)
		navigationController.pushViewController(detailsVC, animated: true)
	}

	func savePlaceWith(mapItem: MKMapItem, marker: MarkerColor, name: String) -> Place {
		let newPlace = Place(mapItem: mapItem, name: name, category: marker)
		placesCtrl.addPlace(newPlace)
		return newPlace
	}

	func start() {

	}
}
