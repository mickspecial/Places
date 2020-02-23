//
//  HomeDetailsViewController.swift
//  Places
//
//  Created by Michael Schembri on 8/4/19.
//  Copyright © 2019 Michael Schembri. All rights reserved.
//

import UIKit
import MapKit

protocol PlaceDetailsViewControllerDelegate: AnyObject {
	func dismissChildViewController()
}

class PlaceDetailsViewController: UIViewController {

	private let detailsView = PlaceDetailsView()
	let coordinator: PlaceListCoordinator
	let place: Place
	let markerPicker = UIPickerView()
	var pickerData = [(key: MarkerColor, value: String)]()
	var markerColor: MarkerColor!
	weak var delegate: PlaceDetailsViewControllerDelegate?

	init(coordinator: PlaceListCoordinator, place: Place) {
		self.coordinator = coordinator
		self.place = place
		self.markerColor = place.category
		super.init(nibName: nil, bundle: nil)
	}

	override func loadView() {
		view = detailsView
	}

	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		view.endEditing(true)
	}

	@objc func makeScreenBlack() {
		detailsView.subviews.forEach { (view) in
			view.isHidden = true
		}
	}

	@objc func keyboardDidAppear() {
		canBeDismissed = false
	}

	@objc func keyboardDidDisappear() {
		canBeDismissed = true
	}

	// pop the VC only when there is no KB showing - otherwise dismiss the KB only
	var canBeDismissed = true

	override func viewDidLoad() {
		super.viewDidLoad()
		detailsView.nameTF.delegate = self
		detailsView.layer.cornerRadius = 10
		navigationController?.navigationBar.isHidden = true
		setUpView()
		// convert dict to tuple so can easily manage data
		pickerData = User.current.categories.map { (key: MarkerColor, value: String) in
			return (key, value)
		}

		pickerData.sort(by: { $0.value < $1.value })
		categoryPickerSetUp()
		navigationItem.rightBarButtonItem = UIBarButtonItem.menuButton(self, action: #selector(goToPlace), imageName: "navigation", size: .small)
	}

	func categoryPickerSetUp() {
//		markerPicker.showsSelectionIndicator = true
		markerPicker.delegate = self
		markerPicker.dataSource = self
		detailsView.categoryTF.inputView = markerPicker
		if let index = pickerData.firstIndex(where: { $0.key == place.category }) {
			markerPicker.selectRow(index, inComponent: 0, animated: false)
		}
	}

	private func setUpView() {
		view.backgroundColor = Theme.current.primaryDark
		title = place.name
		detailsView.deleteButton.addTarget(self, action: #selector(deletePlace), for: .touchUpInside)
		detailsView.mapView.delegate = self
	}

	func removeMap() {
		detailsView.mapView.removeConstraints(detailsView.mapView.constraints)
		detailsView.mapView.constrainHeight(constant: 1)
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.detailsView.mapView.addAnnotation(self.place)
		self.detailsView.mapView.showAnnotations([self.place], animated: true)
		detailsView.nameTF.text = place.name
		detailsView.categoryTF.text = User.current.categories[place.category]

		NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidDisappear), name: UIResponder.keyboardDidHideNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidAppear), name: UIResponder.keyboardDidShowNotification, object: nil)
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)

		UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
			self.detailsView.mapHeightCons?.constant = 300
			self.detailsView.layoutIfNeeded()
		}, completion: { _ in
			// nil
		})
	}

	@objc func goToPlace() {
		let destination = MKMapItem(placemark: MKPlacemark(coordinate: place.coordinate))
		destination.name = place.name

		MKMapItem.openMaps(with: [destination], launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
	}

	@objc func deletePlace() {
		let alert = SCLAlertView(appearance: AlertService.standardNoCloseButtonH)

		alert.addButton("Cancel", backgroundColor: Theme.current.cellDark, textColor: .white, showTimeout: nil) {
			return
		}

		alert.addButton("Delete") {
			guard let delegate = self.delegate else { return }
			self.coordinator.deletePlace(self.place, delegate: delegate)
		}

		alert.showError("Delete Place?")
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		let selectedMarker = pickerData[markerPicker.selectedRow(inComponent: 0)]
		if selectedMarker.value != detailsView.categoryTF.string {
			// pasted in junk
			return
		}
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
		return User.current.categories.count
	}
}

extension PlaceDetailsViewController: UITextFieldDelegate {

	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.endEditing(true)
		return true
	}
}
