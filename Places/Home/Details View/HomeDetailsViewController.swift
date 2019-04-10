//
//  HomeDetailsViewController.swift
//  Places
//
//  Created by Michael Schembri on 8/4/19.
//  Copyright © 2019 Michael Schembri. All rights reserved.
//

import UIKit
import MapKit

class HomeDetailsViewController: UIViewController {

	private let detailsView = HomeDetailsView()
	let coordinator: HomeCoordinator
	let place: Place

	init(coordinator: HomeCoordinator, place: Place) {
		self.coordinator = coordinator
		self.place = place
		super.init(nibName: nil, bundle: nil)
	}

	override func loadView() {
		view = detailsView
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		setUpView()
	}

	private func setUpView() {
		view.backgroundColor = .white
		title = place.name
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Delete", style: .done, target: self, action: #selector(deletePlace))
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		detailsView.mapView.addAnnotation(place)
		detailsView.mapView.showAnnotations([place], animated: false)
		detailsView.nameTF.text = place.name
	}

	@objc func deletePlace() {
		coordinator.deletePlace(place)
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		coordinator.updatePlace(place, name: detailsView.nameTF.string)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
