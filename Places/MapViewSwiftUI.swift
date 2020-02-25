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

		print("UPDATED")
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

		// check the start and end pins and change image as required
		// do i need this as well as in selected and deseleted ???
		for annotation in uiView.annotations {
			guard let placeAnnotation = annotation as? Place else { return }

			// normal image
			if let myView = uiView.view(for: annotation) {
				myView.image = placeAnnotation.markerImage
				myView.centerOffset = CGPoint(x: 0, y: 0)
			}

			if let startPin = self.startPin, startPin == placeAnnotation {
				if let myView = uiView.view(for: annotation) {
					myView.image = placeAnnotation.startImage
					myView.centerOffset = CGPoint(x: 0, y: -myView.frame.size.height / 2)
				}
			}

			if let endPin = self.endPin, endPin == placeAnnotation {
				if let myView = uiView.view(for: annotation) {
					myView.image = placeAnnotation.endImage
					myView.centerOffset = CGPoint(x: 0, y: -myView.frame.size.height / 2)
				}
			}
		}

		assert(places.count == uiView.annotations.count)
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

	final class Coordinator: NSObject, MKMapViewDelegate {
		//var control: MapViewSwiftUI
		let locationManager = CLLocationManager()

		@Binding var selectedPin: Place?
		@Binding var highlighted: Place?
		@Binding var startPin: Place?
		@Binding var endPin: Place? {
			didSet {
				dosomeStuff()
			}
		}

		func dosomeStuff() {
			print("do it .....")
		}

		func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
//			guard let coordinates = view.annotation?.coordinate else { return }
//			let span = mapView.region.span
//			let region = MKCoordinateRegion(center: coordinates, span: span)
//			mapView.setRegion(region, animated: true)
			print("TAP.....")

			guard let pin = view.annotation as? Place else {
				return
			}

			DispatchQueue.main.async {
				//	pin.action?()
				self.selectedPin = pin

//				for annotation in mapView.annotations {
//					guard let placeAnnotation = annotation as? Place else { return }
//
//					if placeAnnotation == self.selectedPin! {
//						if let myView = mapView.view(for: annotation) {
//							myView.image = placeAnnotation.selectedImage
//							//myView.centerOffset = CGPoint(x: 0, y: -myView.frame.size.height / 2)
//						}
//					}
//				}
			}
		}

		init(selectedPin: Binding<Place?>, highlighted: Binding<Place?>, startPin: Binding<Place?>, endPin: Binding<Place?>) {
            _selectedPin = selectedPin
			_highlighted = highlighted
			_startPin = startPin
			_endPin = endPin
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
			print("DESELETED")

			DispatchQueue.main.async {

				self.selectedPin = nil
				self.highlighted = nil

			}

//			for annotation in mapView.annotations {
//				print("Check")
//				guard let placeAnnotation = annotation as? Place else { return }
//
//				if let myView = mapView.view(for: annotation) {
//					// reset
//					myView.image = placeAnnotation.markerImage
//					myView.centerOffset = CGPoint(x: 0, y: 0)
//
//				}
//			}

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

struct ZoomMapViewSwiftUI2: UIViewRepresentable {

	var place: Place

	func updateUIView(_ uiView: MKMapView, context: Context) {
		updateAnnotations(from: uiView)
		let coordinate = place.coordinate
		let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        uiView.setRegion(region, animated: true)
	}

	private func updateAnnotations(from mapView: MKMapView) {
		mapView.removeAnnotations(mapView.annotations)
		mapView.addAnnotations([place])
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
		var control: ZoomMapViewSwiftUI2

		init(_ control: ZoomMapViewSwiftUI2) {
			self.control = control
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

			private func placeAnnotationView(for annotation: MKAnnotation, map: MKMapView) -> MKAnnotationView {
				guard let placeAnnotation = annotation as? Place else { fatalError() }
				let identifier = "Annotation"
				var annotationView = map.dequeueReusableAnnotationView(withIdentifier: identifier)
				annotationView = MKAnnotationView(annotation: placeAnnotation, reuseIdentifier: identifier)
				annotationView!.image = placeAnnotation.markerImage

				return annotationView!
			}

	}
}
