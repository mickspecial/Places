//
//  DetailsView.swift
//  Places
//
//  Created by Michael Schembri on 9/4/19.
//  Copyright © 2019 Michael Schembri. All rights reserved.
//

import UIKit
import MapKit

class HomeDetailsView: UIView {

	var mapView: MKMapView!

	let nameTF: UITextField = {
		let tf = UITextField()
		tf.heightAnchor.constraint(equalToConstant: 50).isActive = true
		return tf
	}()

	private var	nameLabel: UILabel = {
		let label = UILabel(frame: .zero)
		label.font = UIFont.systemFont(ofSize: 10, weight: .bold)
		label.textColor = .darkGray
		label.text = "Name"
		return label
	}()

	override init(frame: CGRect) {
		super.init(frame: frame)
		setupView()
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setupView()
	}

	override func layoutSubviews() {
		super.layoutSubviews()
		mapView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, size: CGSize(width: frame.size.width, height: frame.size.height / 2))
	}

	private func setupView() {
		mapView = MKMapView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
		mapView.isUserInteractionEnabled = false

		addSubview(mapView)
		addSubview(nameTF)
		addSubview(nameLabel)
		mapView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor)
		nameLabel.anchor(top: mapView.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 10, left: 10, bottom: 0, right: 10))
		nameTF.anchor(top: nameLabel.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 0, left: 10, bottom: 0, right: 10))
	}
}
