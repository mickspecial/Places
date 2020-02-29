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

	var locationManager = CLLocationManager()

	func setupManager() {
	  locationManager.desiredAccuracy = kCLLocationAccuracyBest
	  locationManager.requestWhenInUseAuthorization()
	  locationManager.requestAlwaysAuthorization()
	}

	func updateUIView(_ uiView: MKMapView, context: Context) {
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

		if self.endPin == nil || self.startPin == nil {
			self.removeOverlays(from: uiView)
		}

		//assert(places.count == uiView.annotations.count)
	}

	func drawRoute(map: MKMapView) {
		guard let start = startPin, let end = endPin else {
			self.removeOverlays(from: map)
			return
		}

		if start == end {
			return
		}

		let directionRequest = MKDirections.Request()
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

	func addRoute(route: MKRoute, to mapView: MKMapView) {
		self.removeOverlays(from: mapView)

		print("ADD ROUTE")
		let polyline = route.polyline
		mapView.addOverlay(polyline, level: .aboveRoads)

		let routeInfo = RouteDetails(route: route)
		mapView.addAnnotation(routeInfo)

		// 	if want to zoom into route
		//	let rect = route.polyline.boundingMapRect
		//	self.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
	}

	func removeOverlays(from mapView: MKMapView) {
		mapView.removeOverlays(mapView.overlays)
		if let routeInfo = mapView.annotations.first(where: { $0 is RouteDetails }) {
			mapView.removeAnnotation(routeInfo)
		}
	}

	func makeCoordinator() -> Coordinator {
		Coordinator(selectedPin: $selectedPin, highlighted: $highlighted, startPin: $startPin, endPin: $endPin)
	}

	func makeUIView(context: Context) -> MKMapView {
		setupManager()

		let map = MKMapView()
		map.delegate = context.coordinator
		map.isRotateEnabled = false

		map.showsUserLocation = true
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

		}

		init(selectedPin: Binding<Place?>, highlighted: Binding<Place?>, startPin: Binding<Place?>, endPin: Binding<Place?>) {
            _selectedPin = selectedPin
			_highlighted = highlighted
			_startPin = startPin
			_endPin = endPin
        }

		func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
			let renderer = MKPolylineRenderer(overlay: overlay)
			renderer.strokeColor = UIColor.FlatColor.Red.Cinnabar
			renderer.lineWidth = 3.0
			return renderer
		}

		func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
			if let annotation = annotation as? RouteDetails {
				return annotation.annotationView
			}

			if annotation is Place {
				let annotationView = placeAnnotationView(for: annotation, map: mapView)
				return annotationView
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
