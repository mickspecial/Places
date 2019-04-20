//
//  HomeCoordinator.swift
//  Places
//
//  Created by Michael Schembri on 8/4/19.
//  Copyright © 2019 Michael Schembri. All rights reserved.
//

import UIKit

class PlaceListCoordinator: Coordinator {

	var childCoordinators = [Coordinator]()
	var navigationController: UINavigationController
	var tabCtrl: MainTabBarController

	init(navigationController: UINavigationController = UINavigationController(), tabCtrl: MainTabBarController) {
		self.navigationController = navigationController
		self.tabCtrl = tabCtrl

		self.navigationController.navigationBar.prefersLargeTitles = true
		self.navigationController.navigationBar.isTranslucent = false

		let home = PlaceListController(coordinator: self)
		home.tabBarItem = UITabBarItem(title: "Places", image: #imageLiteral(resourceName: "list"), tag: 0)
		navigationController.viewControllers = [home]
	}

//	func showDetails(_ place: Place) {
//		let homeVC = PlaceDetailsViewController(coordinator: self, place: place)
//		navigationController.pushViewController(homeVC, animated: true)
//	}

	func showDetailsVC(_ place: Place) -> UIViewController {
		let homeVC = PlaceDetailsViewController(coordinator: self, place: place)
		return homeVC
	}

	func showOnMap(_ place: Place) {
		tabCtrl.changeTabZoomToPlace(place: place)
	}

	func deletePlace(_ place: Place) {
		print("Delete - \(place.name)")
		User.current.markAsDeletedPlace(place)
		navigationController.popViewController(animated: true)
	}

	func showCategories() {
		let catVC = CategoryViewController(coordinator: self)
		navigationController.pushViewController(catVC, animated: true)
	}

	func updatePlace(_ place: Place, name: String, category: MarkerColor) {
		if (name == place.name && category == place.category) || name.isEmpty {
			return
		}

		print("Update - \(place.name)")
		User.current.updatePlace(place: place, name: name, category: category)
	}

	func start() {

	}
}
