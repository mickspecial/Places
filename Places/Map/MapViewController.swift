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

class MapViewController: UIViewController, MKMapViewDelegate {

	var mapView: MKMapView!
	let placesController: PlacesController
	let locationManager = CLLocationManager()

	let start: UIButton = {
		let button = UIButton(type: .system)
		button.setTitle("Start", for: .normal)
		button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
		button.setTitleColor(.white, for: .normal)
		button.backgroundColor = UIColor.FlatColor.Green.Fern
		button.tag = ButtonTag.start.rawValue
		return button
	}()

	var startLabel: UILabel = {
		let label = UILabel(frame: .zero)
		label.textColor = .white
		label.font = UIFont.systemFont(ofSize: 13, weight: .bold)
		return label
	}()

	var endLabel: UILabel = {
		let label = UILabel(frame: .zero)
		label.textColor = .white
		label.font = UIFont.systemFont(ofSize: 13, weight: .bold)
		return label
	}()

	enum ButtonTag: Int {
		case start, end
	}

	let end: UIButton = {
		let button = UIButton(type: .system)
		button.setTitle("End", for: .normal)
		button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
		button.setTitleColor(.white, for: .normal)
		button.backgroundColor = UIColor.FlatColor.Red.TerraCotta
		button.tag = ButtonTag.end.rawValue
		return button
	}()

	var startPoint: Place? {
		didSet {
			switch checkPlace(new: startPoint, other: endPoint) {
			case .placeIsEmpty:
				startLabel.text = ""
			case .matchesOtherPlace(let new):
				startLabel.text = "\(new.name) \(new.address)"
				endPoint = nil // remove other point
				removeOverlaysFromMap()
			case .okToRoute(let new):
				startLabel.text = "\(new.name) \(new.address)"
				drawRoute()
			case .missingOtherPlace(let new):
				startLabel.text = "\(new.name) \(new.address)"
			}
		}
	}

	var endPoint: Place? {
		didSet {
			switch checkPlace(new: endPoint, other: startPoint) {
			case .placeIsEmpty:
				endLabel.text = ""
			case .matchesOtherPlace(let new):
				endLabel.text = "\(new.name) \(new.address)"
				startPoint = nil // remove other point
				removeOverlaysFromMap()
			case .okToRoute(let new):
				endLabel.text = "\(new.name) \(new.address)"
				drawRoute()
			case .missingOtherPlace(let new):
				endLabel.text = "\(new.name) \(new.address)"
			}
		}
	}

	@objc func startEndButtonTapped(sender: UIButton) {
		guard let tag = ButtonTag(rawValue: sender.tag) else { fatalError() }
		guard let selectedPlace = mapView.selectedAnnotations.first else { return }

		// select place pin or the default current location marker
		let place = selectedPlace as? Place ?? Place(currentLocation: selectedPlace.coordinate)

		switch tag {
		case .start: startPoint = place
		case .end: endPoint = place
		}
	}

	func checkPlace(new: Place?, other: Place?) -> PlaceSetOptions {
		if new == nil {
			return .placeIsEmpty
		}

		if let new = new, other == nil {
			return .missingOtherPlace(newPlace: new)
		}

		guard let new = new, let other = other else { fatalError() }

		if new.id == other.id {
			return .matchesOtherPlace(newPlace: new)
		}

		return .okToRoute(newPlace: new)
	}

	enum PlaceSetOptions {
		case placeIsEmpty
		case matchesOtherPlace(newPlace: Place)
		case okToRoute(newPlace: Place)
		case missingOtherPlace(newPlace: Place)
	}

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
		addToFromButtons()
    }

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		// dont remove route details ie 14 min
		let places = mapView.annotations.filter({ $0 is Place })
		mapView.removeAnnotations(places)

		mapView.addAnnotations(placesController.places)
		showUsersLocationOnMap()
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		mapView.showAnnotations(placesController.places, animated: true)
	}

	override func viewWillDisappear(_ animated: Bool) {
		locationManager.stopUpdatingLocation()
	}

	private func setUpView() {
		title = "Map"
		view.backgroundColor = Theme.current.primary
		navigationController?.navigationBar.prefersLargeTitles = true
		navigationController?.navigationBar.isTranslucent = false
		let route = UIBarButtonItem.menuButton(self, action: #selector(goToPlace), imageName: "navigation", size: .medium)
		let reset = UIBarButtonItem.init(title: "Clear", style: .plain, target: self, action: #selector(clearPressed))
		navigationItem.rightBarButtonItems = [route, reset]
	}

	private func addMapToView() {
		mapView = MKMapView(frame: view.frame)
		mapView.delegate = self
		mapView.showsUserLocation = true
		view.addSubview(mapView)
		mapView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 80, left: 0, bottom: 0, right: 0))
	}

	private func addToFromButtons() {
		view.addSubview(start)
		view.addSubview(end)
		view.addSubview(startLabel)
		view.addSubview(endLabel)
		start.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, size: .init(width: 80, height: 40))
		end.anchor(top: nil, leading: view.leadingAnchor, bottom: mapView.topAnchor, trailing: nil, size: .init(width: 80, height: 40))
		end.addTarget(self, action: #selector(startEndButtonTapped), for: .touchUpInside)
		start.addTarget(self, action: #selector(startEndButtonTapped), for: .touchUpInside)
		startLabel.anchor(top: start.topAnchor, leading: start.trailingAnchor, bottom: start.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 10, bottom: 0, right: 0))
		endLabel.anchor(top: end.topAnchor, leading: end.trailingAnchor, bottom: end.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 10, bottom: 0, right: 0))
	}

	@objc func clearPressed() {
		removeOverlaysFromMap()
		startPoint = nil
		endPoint = nil
		mapView.showAnnotations(placesController.places, animated: true)
	}

	func removeOverlaysFromMap() {
		mapView.removeOverlays(mapView.overlays)
		let routeInfo = mapView.annotations.filter({ $0 is RouteDetails })
		mapView.removeAnnotations(routeInfo)
	}

	@objc func goToPlace() {

		guard let endPoint = endPoint else {
			SCLAlertView(appearance: AlertService.standard).showError("Route Details Missing")
			return
		}

		var showMapItems = [endPoint.placeMapItem]

		// no need to send start point to maps if its current location
		if let startPoint = startPoint, startPoint.name != "Current Location" {
			showMapItems.append(startPoint.placeMapItem)
		}

		// can show map if just end point - maps will use current location by default as start point
		MKMapItem.openMaps(with: showMapItems, launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
	}

	private func showUsersLocationOnMap() {
		locationManager.requestWhenInUseAuthorization()

		if CLLocationManager.locationServicesEnabled() {
			locationManager.delegate = self
			locationManager.desiredAccuracy = kCLLocationAccuracyBest
			//locationManager.startUpdatingLocation()
			locationManager.requestLocation()
		}
	}

	func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
		if let annotation = annotation as? RouteDetails {
			return annotation.annotationView
		}

		if annotation is Place {
			let annotationView = placeAnnotationView(for: annotation)
			return annotationView
		}

		return nil
	}

	private func placeAnnotationView(for annotation: MKAnnotation) -> MKAnnotationView {
		guard annotation is Place else { fatalError() }
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
		return annotationView!
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

	func drawRoute() {
		guard let start = startPoint, let end = endPoint else { return }
		removeOverlaysFromMap()

		let directionRequest = MKDirections.Request()
		directionRequest.source = start.placeMapItem
		directionRequest.destination = end.placeMapItem
		directionRequest.transportType = .automobile

		let directions = MKDirections(request: directionRequest)

		directions.calculate { (response, _ ) -> Void in
			guard let response = response else { return }
			let route = response.routes[0]
			self.addRoute(route: route)
		}
	}

	func addRoute(route: MKRoute) {
		let polyline = route.polyline
		let routeInfo = RouteDetails(route: route)
		self.mapView.addOverlay(polyline, level: .aboveRoads)
		self.mapView.addAnnotation(routeInfo)
		// 	if want to zoom into route
		//	let rect = route.polyline.boundingMapRect
		//	self.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
	}

	func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
		let renderer = MKPolylineRenderer(overlay: overlay)
		renderer.strokeColor = UIColor.FlatColor.Red.Cinnabar
		renderer.lineWidth = 3.0
		return renderer
	}
}

extension MapViewController: CLLocationManagerDelegate {

	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		print(error.localizedDescription)
	}

	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		print("location for user")
	}
}
