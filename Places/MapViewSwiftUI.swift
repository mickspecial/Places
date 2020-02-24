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

	var locationManager = CLLocationManager()

	func setupManager() {
	  locationManager.desiredAccuracy = kCLLocationAccuracyBest
	  locationManager.requestWhenInUseAuthorization()
	  locationManager.requestAlwaysAuthorization()
	}

	func updateUIView(_ uiView: MKMapView, context: Context) {
		updateAnnotations(from: uiView)
	}

	private func updateAnnotations(from mapView: MKMapView) {
		mapView.addAnnotations(places)

		if self.highlighted != nil {
			// zooms to specific one
			mapView.showAnnotations([highlighted!], animated: true)
			mapView.selectAnnotation(highlighted!, animated: true)
			// then turn off
		} else {
			if selectedPin == nil {
				// zoom level to show all on map at best scale
				mapView.showAnnotations(mapView.annotations, animated: true)
			} else {
				// dont move the view port when tapping on item
			}

		}

		assert(places.count == mapView.annotations.count)
	}

	func makeCoordinator() -> Coordinator {
		Coordinator(selectedPin: $selectedPin)
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
				pin.action?()
				self.selectedPin = pin
			}
		}

		init(selectedPin: Binding<Place?>) {
            _selectedPin = selectedPin
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
			self.selectedPin = nil
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
