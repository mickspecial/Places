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
	let startEndViewCtrl = StartEndViewController()

	var startPoint: Place? {
		didSet {
			switch PlaceSetOptions(new: startPoint, other: endPoint) {
			case .placeIsEmpty:
				startEndViewCtrl.startLabel.text = ""
			case .matchesOtherPlace(let new):
				startEndViewCtrl.startLabel.text = "\(new.name) \(new.address)"
				endPoint = nil // remove other point
				removeOverlaysFromMap()
			case .okToRoute(let new):
				startEndViewCtrl.startLabel.text = "\(new.name) \(new.address)"
				drawRoute()
			case .missingOtherPlace(let new):
				startEndViewCtrl.startLabel.text = "\(new.name) \(new.address)"
			}
		}
	}

	var endPoint: Place? {
		didSet {
			switch PlaceSetOptions(new: endPoint, other: startPoint) {
			case .placeIsEmpty:
				startEndViewCtrl.endLabel.text = ""
			case .matchesOtherPlace(let new):
				startEndViewCtrl.endLabel.text = "\(new.name) \(new.address)"
				startPoint = nil // remove other point
				removeOverlaysFromMap()
			case .okToRoute(let new):
				startEndViewCtrl.endLabel.text = "\(new.name) \(new.address)"
				drawRoute()
			case .missingOtherPlace(let new):
				startEndViewCtrl.endLabel.text = "\(new.name) \(new.address)"
			}
		}
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
		addStartEndChildViewController()
    }

	private func addStartEndChildViewController() {
		addChild(startEndViewCtrl)
		startEndViewCtrl.delegate = self
		startEndViewCtrl.view.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: 80)
		view.addSubview(startEndViewCtrl.view)
		startEndViewCtrl.didMove(toParent: self)
	}

	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
		startEndViewCtrl.view.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: mapView.topAnchor, trailing: view.trailingAnchor)
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
			// if use add stopUpdatingLocation in view will disappear
			//locationManager.startUpdatingLocation()
			// single call
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
		guard let placeAnnotation = annotation as? Place else { fatalError() }
		let identifier = "Annotation"
		var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)

		if annotationView == nil {
			annotationView = MKAnnotationView(annotation: placeAnnotation, reuseIdentifier: identifier)
			annotationView!.canShowCallout = true
		} else {
			annotationView!.annotation = placeAnnotation
		}

		// add pin image
		annotationView!.image = placeAnnotation.markerImage

		// add callout view
		let callout = PinCalloutView(place: placeAnnotation)
		annotationView!.detailCalloutAccessoryView = callout
		callout.centerInSuperview(size: CGSize(width: 150, height: 60))

		return annotationView!
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

extension MapViewController: StartEndViewControllerDelegate {

	func startEndWasTapped(button: StartEndViewController.ButtonTag) {
		guard let selectedPlace = mapView.selectedAnnotations.first else { return }
		// select place pin or the default current location marker
		let place = selectedPlace as? Place ?? Place(currentLocation: selectedPlace.coordinate)

		switch button {
		case .start: startPoint = place
		case .end: endPoint = place
		}
	}
}
