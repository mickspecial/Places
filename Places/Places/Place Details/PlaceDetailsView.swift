//
//  DetailsView.swift
//  Places
//
//  Created by Michael Schembri on 9/4/19.
//  Copyright © 2019 Michael Schembri. All rights reserved.
//

import UIKit
import MapKit

class PlaceDetailsView: UIView {

	var mapView: MKMapView!

	let nameTF: UITextField = {
		let tf = UITextField()
		tf.textColor = .white
		tf.heightAnchor.constraint(equalToConstant: 50).isActive = true
		return tf
	}()

	let categoryTF: UITextField = {
		let tf = UITextField()
		tf.textColor = .white
		tf.heightAnchor.constraint(equalToConstant: 50).isActive = true
		return tf
	}()

	private var	nameLabel: UILabel = {
		let label = UILabel(frame: .zero)
		label.font = UIFont.systemFont(ofSize: 10, weight: .bold)
		label.textColor = .orange
		label.text = "Name"
		return label
	}()

	private var categoryLabel: UILabel = {
		let label = UILabel(frame: .zero)
		label.font = UIFont.systemFont(ofSize: 10, weight: .bold)
		label.textColor = .orange
		label.text = "Category"
		return label
	}()

	let deleteButton: UIButton = {
		let button = UIButton(type: .system)
		button.setTitle("Delete", for: .normal)
		button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
		button.setTitleColor(UIColor.FlatColor.Red.Valencia, for: .normal)
		return button
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
		mapView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, size: CGSize(width: frame.size.width, height: frame.size.height / 3))
	}

	private func setupView() {
		mapView = MKMapView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
		mapView.isUserInteractionEnabled = false

		addSubview(mapView)
		addSubview(nameTF)
		addSubview(nameLabel)
		addSubview(categoryTF)
		addSubview(categoryLabel)
		addSubview(deleteButton)
		mapView.anchor(top: layoutMarginsGuide.topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor)
		nameLabel.anchor(top: mapView.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 10, left: 10, bottom: 0, right: 10))
		nameTF.anchor(top: nameLabel.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 0, left: 10, bottom: 0, right: 10))
		categoryLabel.anchor(top: nameTF.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 10, left: 10, bottom: 0, right: 10))
		categoryTF.anchor(top: categoryLabel.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 0, left: 10, bottom: 0, right: 10))
		deleteButton.anchor(top: nil, leading: nil, bottom: bottomAnchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: 20, right: 0), size: .init(width: 80, height: 40))
		deleteButton.centerX()
	}
}
