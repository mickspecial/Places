//
//  Coordinator.swift
//  Places
//
//  Created by Michael Schembri on 7/4/19.
//  Copyright © 2019 Michael Schembri. All rights reserved.
//

import UIKit

protocol Coordinator {
	var childCoordinators: [Coordinator] { get set }
	var navigationController: UINavigationController { get set }
	func start()
}

class MainTabBarController: UITabBarController {

	var homeCoordinator: HomeCoordinator!
	var mapSeachCoordinator: FindCoordinator!
	var placesController: PlacesController!
	var categoriesController: CategoryController!

	override func viewDidLoad() {
		super.viewDidLoad()
		placesController = PlacesController()
		categoriesController = CategoryController()
		// if VC needs more advanced actions set it up with a coordinator
		homeCoordinator = HomeCoordinator(placesCtrl: placesController)

		let map = MapViewController(placesCtrl: placesController)
		map.tabBarItem = UITabBarItem(title: "Map", image: #imageLiteral(resourceName: "marker"), tag: 1)

		mapSeachCoordinator = FindCoordinator(placesCtrl: placesController, categoriesCtrl: categoriesController)

//		let find = FindTableViewController(placesCtrl: placesController, categoriesCtrl: categoriesController)
//		find.tabBarItem = UITabBarItem(title: "Find", image: #imageLiteral(resourceName: "find"), tag: 2)

		viewControllers = [
			homeCoordinator.navigationController,
			UINavigationController(rootViewController: map),
			mapSeachCoordinator.navigationController
		]
	}
}
