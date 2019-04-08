//
//  HomeViewController.swift
//  Places
//
//  Created by Michael Schembri on 7/4/19.
//  Copyright © 2019 Michael Schembri. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

	let placesController: PlacesController!
	let coordinator: HomeCoordinator!

	init(placesCtrl: PlacesController, coordinator: HomeCoordinator) {
		self.placesController = placesCtrl
		self.coordinator = coordinator
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

    override func viewDidLoad() {
        super.viewDidLoad()
		view.backgroundColor = .white
		title = "Places"
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(showNextTest))
    }

	@objc func showNextTest() {
		coordinator.showNext()
	}
}
