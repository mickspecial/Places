//
//  MapResultViewController.swift
//  Places
//
//  Created by Michael Schembri on 10/4/19.
//  Copyright © 2019 Michael Schembri. All rights reserved.
//

import UIKit
import MapKit

class FindDetailsViewController: UIViewController, MKMapViewDelegate {

	private let detailsView = FindDetailsView()
	let coordinator: FindCoordinator
	let item: MKMapItem
	let categoriesController: CategoryController

	init(coordinator: FindCoordinator, item: MKMapItem, categoriesController: CategoryController) {
		self.coordinator = coordinator
		self.item = item
		self.categoriesController = categoriesController
		super.init(nibName: nil, bundle: nil)
	}

	override func loadView() {
		view = detailsView
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		setUpView()
	}

	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		view.endEditing(true)
	}

	private func setUpView() {
		view.backgroundColor = .white
		title = item.name ?? ""
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(savePlace))
		detailsView.mapView.delegate = self
		let pin = MKPointAnnotation()
		pin.coordinate = item.placemark.coordinate
		detailsView.mapView.addAnnotation(pin)
		detailsView.mapView.showAnnotations([pin], animated: true)
	}

	@objc func savePlace() {
		guard let name = detailsView.nameTF.text, !name.isEmpty else {
			SCLAlertView(appearance: AlertService.standard).showError("Missing Title")
			return
		}

		let newPlace = coordinator.savePlaceWith(mapItem: item, marker: .red, name: name)
		SCLAlertView(appearance: AlertService.standard).showSuccess("Saved")
		view.endEditing(true)
		detailsView.mapView.removeAnnotations(detailsView.mapView.annotations)
		detailsView.mapView.addAnnotation(newPlace)
		title = newPlace.name
	}

	func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
		if annotation is Place {
			let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
			setMarkerImage(for: annotationView)
			return annotationView
		}
		// default pin
		return nil
	}

	private func setMarkerImage(for annotationView: MKAnnotationView) {
		guard let place = annotationView.annotation as? Place else {
			return
		}

		annotationView.image = place.markerImage
	}

	private func titleForMarker(_ marker: MarkerColor) -> String {
		return categoriesController.categories[marker] ?? ""
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
