//
//  HomeDetailsViewController.swift
//  Places
//
//  Created by Michael Schembri on 8/4/19.
//  Copyright © 2019 Michael Schembri. All rights reserved.
//

import UIKit

class HomeDetailsViewController: UIViewController {

	let coordinator: HomeCoordinator!
	let place: Place!

	init(coordinator: HomeCoordinator, place: Place) {
		self.coordinator = coordinator
		self.place = place
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .white
		title = place.name

	}
}
