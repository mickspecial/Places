//
//  MapViewController.swift
//  Places
//
//  Created by Michael Schembri on 7/4/19.
//  Copyright © 2019 Michael Schembri. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

	var mapView: MKMapView!
	var markers = [MKAnnotation]()

    override func viewDidLoad() {
        super.viewDidLoad()
		setUpView()
		addMapToView()

		let test = Place(name: "HERE", details: "A", lat: -28.0051447, long: 153.3507475, id: "1")
		let test2 = Place(name: "Sharks", details: "CCCC", lat: -27.955567312387117, long: 153.3850246667862, id: "2")
		markers = [test, test2]
    }

	private func setUpView() {
		view.backgroundColor = .white
		title = "Map"
	}

	private func addMapToView() {
		mapView = MKMapView(frame: view.frame)
		mapView.delegate = self
		view.addSubview(mapView)
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		mapView.addAnnotations(markers)
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		mapView.showAnnotations(markers, animated: true)
	}

	func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
		guard annotation is Place else { return nil }
		let identifier = "Annotation"
		var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)

		if annotationView == nil {
			annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
			annotationView!.canShowCallout = true
		} else {
			annotationView!.annotation = annotation
		}

		let updatedView = addCustomCallout(to: annotationView!)
		return updatedView
	}

	private func addCustomCallout(to annotationView: MKAnnotationView) -> MKAnnotationView {
		guard let place = annotationView.annotation as? Place else {
			fatalError()
		}

		let callout = PinCalloutView(place: place)
		annotationView.detailCalloutAccessoryView = callout
		callout.centerInSuperview(size: CGSize(width: 100, height: 60))
		return annotationView
	}

	func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
		if let xxx = view.annotation as? Place {
			dump(xxx)
		}
	}
}
