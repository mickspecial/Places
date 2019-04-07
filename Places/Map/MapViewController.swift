//
//  MapViewController.swift
//  Places
//
//  Created by Michael Schembri on 7/4/19.
//  Copyright © 2019 Michael Schembri. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

	var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
		view.backgroundColor = .white
		title = "Map"
    }

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		mapView = MKMapView(frame: view.frame)
		view.addSubview(mapView)
	}
}
