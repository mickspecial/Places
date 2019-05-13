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
		tf.returnKeyType = .done
		tf.constrainHeight(constant: 50)
		return tf
	}()

	let categoryTF: UITextField = {
		let tf = UITextField()
		tf.textColor = .white
		tf.inputAssistantItem.leadingBarButtonGroups.removeAll()
		tf.inputAssistantItem.trailingBarButtonGroups.removeAll()
		tf.constrainHeight(constant: 50)
		return tf
	}()

	private var	nameLabel = UILabel(text: "Name", font: .systemFont(ofSize: 10, weight: .bold), textColor: Theme.current.highlight)
	private var	categoryLabel = UILabel(text: "Category", font: .systemFont(ofSize: 10, weight: .bold), textColor: Theme.current.highlight)
	let deleteButton = UIButton(title: "Delete", titleColor: UIColor.FlatColor.Red.Valencia)

	override init(frame: CGRect) {
		super.init(frame: frame)
		setupView()
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setupView()
	}

	var mapHeightCons: NSLayoutConstraint?

	private func setupView() {
		mapView = MKMapView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
		mapView.isUserInteractionEnabled = false
		mapHeightCons = mapView.heightAnchor.constraint(equalToConstant: 0)
		mapHeightCons?.isActive = true

		addSubviews(mapView, deleteButton)
		mapView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor)

		let namesContainer = UIView()
		let categoryContainer = UIView()
		let container = UIView()
		container.stack(namesContainer.stack(nameLabel, nameTF), categoryContainer.stack(categoryLabel, categoryTF))
		addSubview(container)
		container.anchor(top: mapView.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 10, left: 10, bottom: 0, right: 10))

		deleteButton.anchor(top: nil, leading: nil, bottom: bottomAnchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: 20, right: 0), size: .init(width: 80, height: 40))
		deleteButton.centerXInSuperview()
	}
}
