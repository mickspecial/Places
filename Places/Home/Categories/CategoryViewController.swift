//
//  CategoryViewController.swift
//  Places
//
//  Created by Michael Schembri on 11/4/19.
//  Copyright © 2019 Michael Schembri. All rights reserved.
//

import UIKit

class CategoryViewController: UIViewController {

	let coordinator: HomeCoordinator
	let categoryCtrl: CategoryController

	init(categoryCtrl: CategoryController, coordinator: HomeCoordinator) {
		self.categoryCtrl = categoryCtrl
		self.coordinator = coordinator
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .white
		title = "Categories"
	}

}
