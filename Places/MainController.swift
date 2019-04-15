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

	var homeCoordinator: PlaceListCoordinator!
	var mapSeachCoordinator: FindCoordinator!
	var placesController: PlacesController!
	var categoriesController: CategoryController!
	var mapVC: MapViewController!

	override func viewDidLoad() {
		super.viewDidLoad()
		tabBar.isTranslucent = false

		// set up controllers with user data
		placesController = PlacesController(places: User.current.places)
		// placesController.addTestData()

		categoriesController = CategoryController(categories: User.current.categories)
		// if VC needs more advanced actions set it up with a coordinator

		// Home Tab
		homeCoordinator = PlaceListCoordinator(placesCtrl: placesController, categoryCtrl: categoriesController, tabCtrl: self)

		// Map Tap
		mapVC = MapViewController(placesCtrl: placesController)
		mapVC.tabBarItem = UITabBarItem(title: "Map", image: #imageLiteral(resourceName: "marker"), tag: 1)

		// Find Location Tap
		mapSeachCoordinator = FindCoordinator(placesCtrl: placesController, categoriesCtrl: categoriesController)

		viewControllers = [
			homeCoordinator.navigationController,
			UINavigationController(rootViewController: mapVC),
			mapSeachCoordinator.navigationController
		]
	}

	func changeTabZoomToPlace(place: Place) {
		selectedIndex = 1
		DispatchQueue.delayWithSeconds(1) {
			self.mapVC.zoomToPlace(place: place)
		}
	}
}

extension DispatchQueue {
	static func delayWithSeconds(_ seconds: Double, closure:@escaping () -> Void) {
		DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds, execute: closure)
	}
}
