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

	init(navigationController: UINavigationController = UINavigationController()) {
		self.navigationController = navigationController

		self.navigationController.navigationBar.prefersLargeTitles = true
		self.navigationController.navigationBar.isTranslucent = false

		let findVC = FindListController(coordinator: self)
		findVC.tabBarItem = UITabBarItem(title: "Search", image: #imageLiteral(resourceName: "find"), tag: 2)
		navigationController.viewControllers = [findVC]
	}

	func showDetails(_ item: MKMapItem) {
		let detailsVC = FindDetailsViewController(coordinator: self, item: item)
		navigationController.pushViewController(detailsVC, animated: true)
	}

	func savePlaceWith(mapItem: MKMapItem, marker: MarkerColor, name: String) -> Place {
		let newPlace = Place(mapItem: mapItem, name: name, category: marker)
		User.current.addPlace(newPlace)
		return newPlace
	}

	func start() {

	}
}
