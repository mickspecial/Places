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

	let coordinator: HomeCoordinator!
	let place: Place!
	var mapView: MKMapView!

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
		setUpView()
		addMapToView()
	}

	private func setUpView() {
		view.backgroundColor = .white
		title = place.name
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Delete", style: .done, target: self, action: #selector(deletePlace))
	}

	private func addMapToView() {
		mapView = MKMapView(frame: .zero)
		mapView.isUserInteractionEnabled = false
		view.addSubview(mapView)
		mapView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, size: CGSize(width: view.frame.size.width, height: view.frame.size.height / 2))
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		mapView.addAnnotation(place)
		mapView.showAnnotations([place], animated: false)
	}

	@objc func deletePlace() {
		coordinator.deletePlace(place)
	}
}
