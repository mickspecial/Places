//
//  Protocols.swift
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

class MainCoordinator: Coordinator {
	var childCoordinators = [Coordinator]()
	var navigationController: UINavigationController
	var tabCtrl: UITabBarController!

	init(navigationController: UINavigationController = UINavigationController()) {
		self.navigationController = navigationController
	}

	func start() { }
}

class MainTabBarController: UITabBarController {
	let mainCoordinator = MainCoordinator()
	var home: HomeViewController!

	override func viewDidLoad() {
		super.viewDidLoad()
		mainCoordinator.tabCtrl = self

		let home = HomeViewController()
		home.tabBarItem = UITabBarItem(title: "Places", image: #imageLiteral(resourceName: "list"), tag: 0)

		let map = MapViewController()
		map.tabBarItem = UITabBarItem(title: "Map", image: #imageLiteral(resourceName: "marker"), tag: 1)

		viewControllers = [
			UINavigationController(rootViewController: home),
			UINavigationController(rootViewController: map)
		]
	}
}
