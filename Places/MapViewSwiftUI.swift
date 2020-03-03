//
//  MapViewSwiftUI.swift
//  Places
//
//  Created by Michael Schembri on 21/2/20.
//  Copyright © 2020 Michael Schembri. All rights reserved.
//

import SwiftUI
import MapKit

struct MapViewSwiftUI: UIViewRepresentable {

	@Binding var places: [Place]
	@Binding var highlighted: Place?
    @Binding var selectedPin: Place?
	@Binding var startPin: Place?
	@Binding var endPin: Place?
    @State var firstLoad: Bool = true

	// markers for a bounding poly
	@Binding var userPlacedPoints: Set<PolygonAnnotation>

	// route between two pints with distance marker
	@State var currentRouteShowing: MKPolyline?
	@State var currentRouteDistance: MKAnnotation?
	@Binding var dropPinMode: Bool
	@State var directionRequest = MKDirections.Request()

	let map = MKMapView()

	var locationManager = CLLocationManager()

	func setupManager() {
	  locationManager.desiredAccuracy = kCLLocationAccuracyBest
	  locationManager.requestWhenInUseAuthorization()
	  locationManager.requestAlwaysAuthorization()
	}

	func updateUIView(_ uiView: MKMapView, context: Context) {

		print("♻️")

		uiView.addAnnotations(places)

		if firstLoad {
			if highlighted == nil {
				// show all
				uiView.showAnnotations(uiView.annotations, animated: true)
			} else {
				// zoom into highlighted
				let coordinate = highlighted!.coordinate
				let span = MKCoordinateSpan(latitudeDelta: 0.08, longitudeDelta: 0.08)
				let region = MKCoordinateRegion(center: coordinate, span: span)
				uiView.setRegion(region, animated: true)
				uiView.selectAnnotation(highlighted!, animated: true)
			}

			DispatchQueue.main.async {
				self.firstLoad = false
			}
		}

		uiView.annotations.forEach { annotation in

			if let placeAnnotation = annotation as? Place {
				self.colorPlaceMarker(uiView, placeAnnotation: placeAnnotation)
			}

			if let marker = annotation as? MKUserLocation {
				self.colorUserMarker(uiView, marker: marker)
			}
		}

		drawRoute(map: uiView)

		if userPlacedPoints.isEmpty {
			removeCurrentShowingPolygon(from: uiView)
		}
	}

	func drawRoute(map: MKMapView) {

		if self.endPin == nil || self.startPin == nil {
			removeCurrentShowingRoute(from: map)
		}

		guard let start = startPin, let end = endPin else {
			//self.removeOverlays(from: map)
			removeCurrentShowingRoute(from: map)
			return
		}

		if start == end {
			return
		}

		if let prevStart = directionRequest.source, let prevEnd = directionRequest.destination {
			// check these not same as new route so not redrawn
			// good for when have route and then drawing a polygon stops over refresh
			if prevStart == start.placeMapItem && prevEnd == end.placeMapItem {
				return
			}
		}

//		let directionRequest = MKDirections.Request()
		directionRequest.source = start.placeMapItem
		directionRequest.destination = end.placeMapItem
		directionRequest.transportType = .automobile

		let directions = MKDirections(request: directionRequest)

		directions.calculate { (response, _ ) -> Void in
			guard let response = response else { return }
			let route = response.routes[0]
			self.addRoute(route: route, to: map)
		}
	}

	func removeCurrentShowingPolygon(from mapView: MKMapView) {
		// polygon removal
		let poly = mapView.overlays.filter({ $0 is MKPolygon })
		mapView.removeOverlays(poly)

		mapView.annotations.forEach { an in
			// polygon bound markers
			if an is PolygonAnnotation {
				mapView.removeAnnotation(an)
			}

			// polygon label removal
			if an is PolyLabel {
				mapView.removeAnnotation(an)
			}
		}
	}

	func removeCurrentShowingRoute(from mapView: MKMapView) {
		if let current = currentRouteShowing {
			mapView.removeOverlay(current)
		}

		if let currentDist = currentRouteDistance {
			mapView.removeAnnotation(currentDist)
		}
	}

	func addRoute(route: MKRoute, to mapView: MKMapView) {

		removeCurrentShowingRoute(from: mapView)
		print("ADD ROUTE")
		let polyline = route.polyline
		mapView.addOverlay(polyline, level: .aboveRoads)
		// save in local var
		currentRouteShowing = polyline

		let routeInfo = RouteDetails(route: route)
		mapView.addAnnotation(routeInfo)
		// save in local var
		currentRouteDistance = routeInfo

		// 	if want to zoom into route
		//let rect = route.polyline.boundingMapRect
		//mapView.setRegion(MKCoordinateRegion(rect), animated: true)
	}

	func makeCoordinator() -> Coordinator {
		Coordinator(selectedPin: $selectedPin, highlighted: $highlighted, startPin: $startPin, endPin: $endPin, userPlacedPoints: $userPlacedPoints, map: map, dropPinMode: $dropPinMode)
	}

	func makeUIView(context: Context) -> MKMapView {
		setupManager()

		map.delegate = context.coordinator
		map.isRotateEnabled = false
		map.showsUserLocation = true
		//map.do

		let gRecognizer = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.triggerTouchAction(gestureReconizer:)))
		gRecognizer.numberOfTapsRequired = 1
		gRecognizer.numberOfTouchesRequired = 1
		map.addGestureRecognizer(gRecognizer)
		return map
	}

	func colorPlaceMarker(_ uiView: MKMapView, placeAnnotation: Place) {
		// normal image
		if let myView = uiView.view(for: placeAnnotation) {
			myView.image = placeAnnotation.markerImage
			myView.bounds = CGRect(origin: .zero, size: CGSize(width: 30, height: 30))
		}

		if let startPin = self.startPin, startPin == placeAnnotation {
			if let myView = uiView.view(for: placeAnnotation) {
				myView.image = placeAnnotation.startImage
				myView.bounds = CGRect(origin: .zero, size: CGSize(width: 30, height: 30))
				myView.tintColor = .systemGreen
			}
		}

		if let endPin = self.endPin, endPin == placeAnnotation {
			if let myView = uiView.view(for: placeAnnotation) {
				myView.image = placeAnnotation.endImage
				myView.bounds = CGRect(origin: .zero, size: CGSize(width: 30, height: 30))
				myView.tintColor = .systemRed
			}
		}
	}

	func colorUserMarker(_ uiView: MKMapView, marker: MKUserLocation) {

		if let myView = uiView.view(for: marker) {
			 myView.tintColor = nil

		 }

		if let sp = startPin, marker.coordinate.isEqual(sp.coordinate) {
			if let myView = uiView.view(for: marker) {
				myView.tintColor = .systemGreen
			}
			return
		}

		if let ep = endPin, marker.coordinate.isEqual(ep.coordinate) {
			if let myView = uiView.view(for: marker) {
				myView.tintColor = .systemRed
			}
			return
		}
	}

	final class Coordinator: NSObject, MKMapViewDelegate {

		@Binding var selectedPin: Place?
		@Binding var highlighted: Place?
		@Binding var startPin: Place?
		@Binding var endPin: Place?
		@Binding var userPlacedPoints: Set<PolygonAnnotation>
		@Binding var dropPinMode: Bool

		var map: MKMapView

		func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
			if let pin = view.annotation as? Place {
				DispatchQueue.main.async {
					self.selectedPin = pin
				}
				return
			}

			if let userLoc = view.annotation as? MKUserLocation {
				DispatchQueue.main.async {
					self.selectedPin = Place(currentLocation: userLoc.coordinate)
				}
				return
			}

			if let userLoc = view.annotation as? PolygonAnnotation {
				userPlacedPoints.insert(userLoc)
				clearAndAddPoly(to: mapView)
				return
			}

		}

		func clearAndAddPoly(to mapView: MKMapView) {
			let poly = mapView.overlays.filter({ $0 is MKPolygon })
			// clear any polygons that exist
			mapView.removeOverlays(poly)

			let polylabels = mapView.annotations.filter({ $0 is PolyLabel })
			// clear any polygons labels that exist
			mapView.removeAnnotations(polylabels)

			if userPlacedPoints.count >= 3 {
				let coordinates = userPlacedPoints.map { $0.coordinate }
				var hull = coordinates.sortConvex()
				let polygon = MKPolygon(coordinates: &hull, count: hull.count)
				mapView.addOverlay(polygon)

				let area = hull.regionArea()

				let routeInfo = PolyLabel(lat: polygon.coordinate.latitude, long: polygon.coordinate.longitude, info: "", showArea: area)
				mapView.addAnnotation(routeInfo)
				// save in local var ??
			}
		}

		@objc func triggerTouchAction(gestureReconizer: UITapGestureRecognizer) {

			if !dropPinMode {
				return
			}
			//if gestureReconizer.state == .began {
				let locationInView = gestureReconizer.location(in: map)
				let locationOnMap = map.convert(locationInView, toCoordinateFrom: map)

				let new = PolygonAnnotation(coordinate: locationOnMap)
				userPlacedPoints.insert(new)
				// add new marker
				map.addAnnotation(new)
				clearAndAddPoly(to: map)
			//}
		}

		init(selectedPin: Binding<Place?>, highlighted: Binding<Place?>, startPin: Binding<Place?>, endPin: Binding<Place?>, userPlacedPoints: Binding<Set<PolygonAnnotation>>, map: MKMapView, dropPinMode: Binding<Bool>) {
            _selectedPin = selectedPin
			_highlighted = highlighted
			_startPin = startPin
			_endPin = endPin
			_userPlacedPoints = userPlacedPoints
			self.map = map
			_dropPinMode = dropPinMode
        }

		func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {

			if overlay is MKCircle {
				let renderer = MKCircleRenderer(overlay: overlay)
				renderer.fillColor = UIColor.black.withAlphaComponent(0.5)
				renderer.strokeColor = UIColor.blue
				renderer.lineWidth = 2
				return renderer

			} else if overlay is MKPolyline {
				let renderer = MKPolylineRenderer(overlay: overlay)
				renderer.strokeColor = UIColor.FlatColor.Red.Cinnabar
				renderer.lineWidth = 3
				return renderer

			} else if overlay is MKPolygon {
				let renderer = MKPolygonRenderer(polygon: overlay as! MKPolygon)
				renderer.fillColor = UIColor.black.withAlphaComponent(0.5)
				renderer.strokeColor = UIColor.orange
				renderer.lineWidth = 2
				return renderer
			}
			return MKOverlayRenderer()
		}

		func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

			if let annotation = annotation as? RouteDetails {
				return annotation.annotationView
			}

			if let annotation = annotation as? PolyLabel {
				return annotation.annotationView
			}

			if annotation is Place {
				let annotationView = placeAnnotationView(for: annotation, map: mapView)
				return annotationView
			}

			if let annotation = annotation as? PolygonAnnotation {
				let v = MKAnnotationView(annotation: annotation, reuseIdentifier: "poly")
				v.image = annotation.markerImage
				v.bounds = CGRect(origin: .zero, size: CGSize(width: 20, height: 20))

				//let pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "polyAnnotation")
				v.isDraggable = true
				return v
			}

			return nil
		}

		func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
			DispatchQueue.main.async {
				self.selectedPin = nil
				self.highlighted = nil
			}
		}

		private func placeAnnotationView(for annotation: MKAnnotation, map: MKMapView) -> MKAnnotationView {
			guard let placeAnnotation = annotation as? Place else { fatalError() }
			let identifier = "Annotation"
			var annotationView = map.dequeueReusableAnnotationView(withIdentifier: identifier)

			if annotationView == nil {
				annotationView = MKAnnotationView(annotation: placeAnnotation, reuseIdentifier: identifier)
				annotationView!.canShowCallout = true
			} else {
				annotationView!.annotation = placeAnnotation
			}

			// add pin image
			annotationView!.image = placeAnnotation.markerImage
			annotationView!.bounds = CGRect(origin: .zero, size: CGSize(width: 30, height: 30))

			// add callout view
			let callout = PinCalloutView(place: placeAnnotation)
			annotationView!.detailCalloutAccessoryView = callout
			callout.centerInSuperview(size: CGSize(width: 150, height: 60))

			return annotationView!
		}
	}
}

//struct MapViewSwiftUI_Previews: PreviewProvider {
//
//	static let lm = [
//		Place(name: "1", address: "ww", lat: -33.852222, long: 151.21, id: "22", category: .red, isDeleted: false)
//	]
//
//	static let highlights: Place? = nil
//
//    static var previews: some View {
//		MapViewSwiftUI(places: .constant(lm), highlighted: .constant(highlights))
//			.edgesIgnoringSafeArea(.vertical)
//    }
//}

struct ZoomMapViewSwiftUI: UIViewRepresentable {

	@Binding var place: [Place]

	func updateUIView(_ uiView: MKMapView, context: Context) {
		updateAnnotations(from: uiView)
		let coordinate = place.first!.coordinate
		let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        uiView.setRegion(region, animated: true)
	}

	private func updateAnnotations(from mapView: MKMapView) {
		mapView.removeAnnotations(mapView.annotations)
		mapView.addAnnotations(place)
	}

	func makeCoordinator() -> Coordinator {
		Coordinator(self)
	}

	func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
		guard let coordinates = view.annotation?.coordinate else { return }
		let span = mapView.region.span
		let region = MKCoordinateRegion(center: coordinates, span: span)
		mapView.setRegion(region, animated: true)
	}

	func makeUIView(context: Context) -> MKMapView {
		let map = MKMapView()
		map.delegate = context.coordinator
		map.isUserInteractionEnabled = false
		return map
	}

	final class Coordinator: NSObject, MKMapViewDelegate {
		var control: ZoomMapViewSwiftUI

		init(_ control: ZoomMapViewSwiftUI) {
			self.control = control
		}
	}
}

struct DetailsViewMapViewSwiftUI: UIViewRepresentable {

	@Binding var place: Place
	@Binding var marker: MarkerColor

	func updateUIView(_ uiView: MKMapView, context: Context) {

		uiView.addAnnotations([place])

		let coordinate = place.coordinate
		let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        uiView.setRegion(region, animated: true)

		uiView.annotations.forEach { annotation in
			if let myView = uiView.view(for: annotation) {
				myView.image = marker.markerImage
				myView.bounds = CGRect(origin: .zero, size: CGSize(width: 30, height: 30))
			}
		}
	}

	func makeCoordinator() -> Coordinator {
		Coordinator(place: $place, marker: $marker)
	}

	func makeUIView(context: Context) -> MKMapView {
		let map = MKMapView()
		map.delegate = context.coordinator
		map.isUserInteractionEnabled = false
		return map
	}

	final class Coordinator: NSObject, MKMapViewDelegate {

		@Binding var place: Place
		@Binding var marker: MarkerColor

		init(place: Binding<Place>, marker: Binding<MarkerColor>) {
            _place = place
			_marker = marker
        }

		func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
			let renderer = MKPolylineRenderer(overlay: overlay)
			renderer.strokeColor = UIColor.FlatColor.Red.Cinnabar
			renderer.lineWidth = 3.0
			return renderer
		}

		func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
			if annotation is Place {
				let annotationView = placeAnnotationView(for: annotation, map: mapView)
				return annotationView
			}

			return nil
		}

		private func placeAnnotationView(for annotation: MKAnnotation, map: MKMapView) -> MKAnnotationView {
			guard let placeAnnotation = annotation as? Place else { fatalError() }
			let identifier = "Annotation"
			var annotationView = map.dequeueReusableAnnotationView(withIdentifier: identifier)
			annotationView = MKAnnotationView(annotation: placeAnnotation, reuseIdentifier: identifier)
			annotationView!.image = marker.markerImage
			annotationView!.bounds = CGRect(origin: .zero, size: CGSize(width: 30, height: 30))
			return annotationView!
		}
	}
}
