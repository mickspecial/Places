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
	private var places = [Place]()
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

	func zoomToPlace(place: Place) {
		// find place within the local list
		if mapView == nil {
			return
		}

		let places = mapView.annotations.compactMap({ $0 as? Place })
		if let zoomTo = places.first(where: { $0.id == place.id }) {
			//mapView.showAnnotations([zoomTo], animated: true)
			mapView.selectAnnotation(zoomTo, animated: true)
		}
	}

	init() {
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
		places = User.current.places.filter({ $0.isDeleted == false })

		// dont remove route details ie 14 min
		let existsingPlaces = mapView.annotations.filter({ $0 is Place })
		mapView.removeAnnotations(existsingPlaces)

		mapView.addAnnotations(places)
		showUsersLocationOnMap()
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		mapView.showAnnotations(places, animated: true)
	}

	private func setUpView() {
		title = "Map"
		view.backgroundColor = Theme.current.primary
		navigationController?.navigationBar.prefersLargeTitles = true
		navigationController?.navigationBar.isTranslucent = false
		let route = UIBarButtonItem.menuButton(self, action: #selector(goToPlace), imageName: "navigation", size: .small)
		let reset = UIBarButtonItem.menuButton(self, action: #selector(clearPressed), imageName: "clear", size: .xsmall)
		let fixedspacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
		fixedspacer.width = 26
		navigationItem.rightBarButtonItems = [reset, fixedspacer, route]
	}

	private func addMapToView() {
		mapView = MKMapView(frame: view.frame)
		mapView.delegate = self
		mapView.showsUserLocation = true
		mapView.isRotateEnabled = false
		view.addSubview(mapView)
		mapView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 80, left: 0, bottom: 0, right: 0))
	}

	@objc func clearPressed() {
		removeOverlaysFromMap()
		startPoint = nil
		endPoint = nil
		mapView.showAnnotations(places, animated: true)
	}

	func removeOverlaysFromMap() {
		mapView.removeOverlays(mapView.overlays)
		let routeInfo = mapView.annotations.filter({ $0 is RouteDetails })
		mapView.removeAnnotations(routeInfo)
	}

	@objc func goToPlace() {

		guard let endPoint = endPoint else {
			// must have an end point to rout to
			SCLAlertView(appearance: AlertService.standard).showError("Route Details Missing")
			return
		}

		let alert = SCLAlertView(appearance: AlertService.standardNoCloseButtonV)

		alert.addButton("Apple Maps") {
			self.openWithAppleMaps(destination: endPoint)
		}

		if let googleurl = URL(string: "https://maps.google.com"), UIApplication.shared.canOpenURL(googleurl) {
			// add google option if can open in google maps
			alert.addButton("Google Maps") {
				self.openWithGoolgeMaps(destination: endPoint)
			}
		}

		alert.addButton("Cancel", backgroundColor: Theme.current.cellDark, textColor: .white, showTimeout: nil) { return }
		alert.showCustom("Open In", color: UIColor.FlatColor.Blue.Denim)
	}

	func openWithAppleMaps(destination: Place) {
		var showMapItems = [destination.placeMapItem]
		// no need to send start point to maps if its current location
		if let startPoint = startPoint, startPoint.name != "Current Location" {
			showMapItems.append(startPoint.placeMapItem)
		}

		MKMapItem.openMaps(with: showMapItems, launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
	}

	func openWithGoolgeMaps(destination: Place) {
		var url: URL
		// start end
		if let startPoint = startPoint {
			let go = "https://www.google.com/maps/dir/?api=1&origin=\(startPoint.coordinate.latitude),\(startPoint.coordinate.longitude)&destination=\(destination.coordinate.latitude),\(destination.coordinate.longitude)&travelmode=driving"
			url = URL(string: go)!
		} else {
			let go = "https://www.google.com/maps/dir/?api=1&destination=\(destination.coordinate.latitude),\(destination.coordinate.longitude)&travelmode=driving"
			url = URL(string: go)!
		}

		UIApplication.shared.open(url)
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
