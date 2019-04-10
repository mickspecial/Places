//
//  MapResultViewController.swift
//  Places
//
//  Created by Michael Schembri on 10/4/19.
//  Copyright © 2019 Michael Schembri. All rights reserved.
//

import UIKit
import MapKit

class FindDetailsViewController: UIViewController {

	private let detailsView = FindDetailsView()
	let coordinator: FindCoordinator
	let item: MKMapItem
	let categoriesController: CategoryController
	let locationPicker = UIPickerView()
	var pickerData = [(key: MarkerColor, value: String)]()
	var selectedMarker: MarkerColor?

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

		// convert dict to tuple so can easily manage data
		pickerData = categoriesController.categories.map { (key: MarkerColor, value: String) in
			return (key, value)
		}

		pickerData.sort(by: { $0.value < $1.value })
		categoryPickerSetUp()
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
		detailsView.nameTF.delegate = self
		detailsView.categoryTF.delegate = self
	}

	func categoryPickerSetUp() {
		locationPicker.showsSelectionIndicator = true
		locationPicker.delegate = self
		locationPicker.dataSource = self
		detailsView.categoryTF.inputView = locationPicker
	}

	@objc func savePlace() {
		guard let name = detailsView.nameTF.text, !name.isEmpty else {
			SCLAlertView(appearance: AlertService.standard).showError("Missing Title")
			return
		}

		guard let marker = selectedMarker else {
			SCLAlertView(appearance: AlertService.standard).showError("Missing Marker")
			return
		}

		let newPlace = coordinator.savePlaceWith(mapItem: item, marker: marker, name: name)
		SCLAlertView(appearance: AlertService.standard).showSuccess("Saved")
		view.endEditing(true)
		detailsView.mapView.removeAnnotations(detailsView.mapView.annotations)
		detailsView.mapView.addAnnotation(newPlace)
		title = newPlace.name
	}

	private func titleForMarker(_ marker: MarkerColor) -> String {
		return categoriesController.categories[marker] ?? ""
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

extension FindDetailsViewController: MKMapViewDelegate {

	// will show the custom map marker if is a place
	func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
		guard let place = annotation as? Place else {
			return nil // default marker will be used
		}
		let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
		annotationView.image = place.markerImage
		return annotationView
	}
}

// MARK: - UIPickerViewDelegate
extension FindDetailsViewController: UIPickerViewDelegate, UIPickerViewDataSource {

	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return pickerData[row].value
	}

	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		detailsView.categoryTF.text = pickerData[row].value
		selectedMarker = pickerData[row].key
	}

	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}

	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return categoriesController.categories.count
	}
}

extension FindDetailsViewController: UITextFieldDelegate {

	// when TF selected and empty will default to first time in picker data
	func textFieldDidBeginEditing(_ textField: UITextField) {
		if textField == detailsView.categoryTF && textField.string.isEmpty {
			detailsView.categoryTF.text = pickerData.first!.value
			selectedMarker = pickerData.first!.key
		}
	}
}
