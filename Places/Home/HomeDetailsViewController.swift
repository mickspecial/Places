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

	let nameTF: UITextField = {
		let tf = UITextField()
		tf.heightAnchor.constraint(equalToConstant: 50).isActive = true
		return tf
	}()

	private var	nameLabel: UILabel = {
		let label = UILabel(frame: .zero)
		label.font = UIFont.systemFont(ofSize: 10, weight: .bold)
		label.textColor = .darkGray
		return label
	}()

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
		addTextInputs()
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
		nameTF.text = place.name
	}

	@objc func deletePlace() {
		coordinator.deletePlace(place)
	}

	private func addTextInputs() {
		view.addSubview(nameTF)
		view.addSubview(nameLabel)
		nameLabel.anchor(top: mapView.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 10, left: 10, bottom: 0, right: 10))
		nameTF.anchor(top: nameLabel.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 10, bottom: 0, right: 10))
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		coordinator.updatePlace(place, name: nameTF.text ?? "")
	}
}
