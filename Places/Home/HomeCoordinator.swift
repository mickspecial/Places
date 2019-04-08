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

	func showNext() {
		let test = HomeDetailsViewController(coordinator: self)
		navigationController.pushViewController(test, animated: true)
	}

	func start() {

	}
}
