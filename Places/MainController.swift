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
	var mapVC: MapViewController!

	override func viewDidLoad() {
		super.viewDidLoad()
		tabBar.isTranslucent = false

		// set up controllers with user data
		// placesController.addTestData()

		// if VC needs more advanced actions set it up with a coordinator

		// Home Tab
		homeCoordinator = PlaceListCoordinator(tabCtrl: self)

		// Map Tap
		mapVC = MapViewController()
		mapVC.tabBarItem = UITabBarItem(title: "Map", image: #imageLiteral(resourceName: "marker"), tag: 1)

		// Find Location Tap
		mapSeachCoordinator = FindCoordinator()

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
		let when = DispatchTime.now() + seconds
		DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
	}
}
