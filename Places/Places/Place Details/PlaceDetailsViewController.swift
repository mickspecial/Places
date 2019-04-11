//
//  HomeDetailsViewController.swift
//  Places
//
//  Created by Michael Schembri on 8/4/19.
//  Copyright © 2019 Michael Schembri. All rights reserved.
//

import UIKit
import MapKit

class PlaceDetailsViewController: UIViewController {

	private let detailsView = PlaceDetailsView()
	let coordinator: PlaceListCoordinator
	let categoriesController: CategoryController
	let place: Place
	let markerPicker = UIPickerView()
	var pickerData = [(key: MarkerColor, value: String)]()
	var markerColor: MarkerColor!

	init(coordinator: PlaceListCoordinator, place: Place, categoriesController: CategoryController) {
		self.coordinator = coordinator
		self.place = place
		self.markerColor = place.category
		self.categoriesController = categoriesController
		super.init(nibName: nil, bundle: nil)
	}

	override func loadView() {
		view = detailsView
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		setUpView()

		// convert dict to tuple so can easily manage data
		pickerData = categoriesController.categories.map { (key: MarkerColor, value: String) in
			return (key, value)
		}

		pickerData.sort(by: { $0.value < $1.value })
		categoryPickerSetUp()
	}

	func categoryPickerSetUp() {
		markerPicker.showsSelectionIndicator = true
		markerPicker.delegate = self
		markerPicker.dataSource = self
		detailsView.categoryTF.inputView = markerPicker
		if let index = pickerData.firstIndex(where: { $0.key == place.category }) {
			markerPicker.selectRow(index, inComponent: 0, animated: false)
		}
	}

	private func setUpView() {
		view.backgroundColor = .white
		title = place.name
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Delete", style: .done, target: self, action: #selector(deletePlace))
		detailsView.mapView.delegate = self
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		detailsView.mapView.addAnnotation(place)
		detailsView.mapView.showAnnotations([place], animated: false)
		detailsView.nameTF.text = place.name
		detailsView.categoryTF.text = categoriesController.categories[place.category]
	}

	@objc func deletePlace() {
		coordinator.deletePlace(place)
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		let selectedMarker = pickerData[markerPicker.selectedRow(inComponent: 0)]
		assert(selectedMarker.value == detailsView.categoryTF.string)
		coordinator.updatePlace(place, name: detailsView.nameTF.string, category: selectedMarker.key)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

extension PlaceDetailsViewController: MKMapViewDelegate {

	// will show the custom map marker if is a place
	func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
		let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
		annotationView.image = markerColor.markerImage
		return annotationView
	}
}

// MARK: - UIPickerViewDelegate
extension PlaceDetailsViewController: UIPickerViewDelegate, UIPickerViewDataSource {

	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return pickerData[row].value
	}

	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		detailsView.categoryTF.text = pickerData[row].value
		markerColor = pickerData[row].key
		let pin = MKPointAnnotation()
		pin.coordinate = place.coordinate
		detailsView.mapView.removeAnnotations(detailsView.mapView.annotations)
		detailsView.mapView.addAnnotation(pin)
	}

	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}

	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return categoriesController.categories.count
	}
}
