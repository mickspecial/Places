//
//  MapViewController.swift
//  Places
//
//  Created by Michael Schembri on 7/4/19.
//  Copyright © 2019 Michael Schembri. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

	var mapView: MKMapView!
	let placesController: PlacesController
	let locationManager = CLLocationManager()

	init(placesCtrl: PlacesController) {
		placesController = placesCtrl
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

    override func viewDidLoad() {
        super.viewDidLoad()
		setUpView()
		addMapToView()
		showUsersLocationOnMap()
    }

	private func setUpView() {
		view.backgroundColor = .white
		title = "Map"
		navigationController?.navigationBar.prefersLargeTitles = true
		navigationController?.navigationBar.isTranslucent = false
		navigationItem.rightBarButtonItem = UIBarButtonItem.menuButton(self, action: #selector(goToPlace), imageName: "navigation", size: .medium)
	}

	@objc func goToPlace() {
		guard let selected = mapView.selectedAnnotations.first, let place = selected as? Place else {
			SCLAlertView(appearance: AlertService.standard).showError("Select Destinaton")
			return
		}

		let destination = MKMapItem(placemark: MKPlacemark(coordinate: place.coordinate))
		destination.name = place.name

		MKMapItem.openMaps(with: [destination], launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
	}

	private func addMapToView() {
		mapView = MKMapView(frame: view.frame)
		mapView.delegate = self
		mapView.showsUserLocation = true
		view.addSubview(mapView)
		mapView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
	}

	private func showUsersLocationOnMap() {
		locationManager.requestWhenInUseAuthorization()

		if CLLocationManager.locationServicesEnabled() {
			locationManager.delegate = self
			locationManager.desiredAccuracy = kCLLocationAccuracyBest
			locationManager.startUpdatingLocation()
		}

		if let coor = mapView.userLocation.location?.coordinate {
			mapView.setCenter(coor, animated: true)
		}
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		mapView.removeAnnotations(mapView.annotations)
		mapView.addAnnotations(placesController.places)
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		mapView.showAnnotations(placesController.places, animated: true)
	}

	func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
		guard annotation is Place else { return nil }
		let identifier = "Annotation"
		var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)

		if annotationView == nil {
			annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
			annotationView!.canShowCallout = true
		} else {
			annotationView!.annotation = annotation
		}

		addCustomCallout(to: annotationView!)
		setMarkerImage(for: annotationView!)
		return annotationView
	}

	private func setMarkerImage(for annotationView: MKAnnotationView) {
		guard let place = annotationView.annotation as? Place else {
			fatalError()
		}

		annotationView.image = place.markerImage
	}

	private func addCustomCallout(to annotationView: MKAnnotationView) {
		guard let place = annotationView.annotation as? Place else {
			fatalError()
		}

		let callout = PinCalloutView(place: place)
		annotationView.detailCalloutAccessoryView = callout
		callout.centerInSuperview(size: CGSize(width: 150, height: 60))
	}

	func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
		guard let newSelection = view.annotation as? Place else {
			return
		}
		print(newSelection)
	}
}
