//
//  MapResultView.swift
//  Places
//
//  Created by Michael Schembri on 10/4/19.
//  Copyright © 2019 Michael Schembri. All rights reserved.
//

import UIKit
import MapKit

class FindDetailsView: UIView {

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
		// remove copy paste icons
		tf.inputAssistantItem.leadingBarButtonGroups.removeAll()
		tf.inputAssistantItem.trailingBarButtonGroups.removeAll()
		tf.constrainHeight(constant: 50)
		return tf
	}()

	private var	nameLabel = UILabel(text: "Name", font: .systemFont(ofSize: 10, weight: .bold), textColor: Theme.current.highlight)
	private var	categoryLabel = UILabel(text: "Category", font: .systemFont(ofSize: 10, weight: .bold), textColor: Theme.current.highlight)

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
		mapView.anchor(top: safeAreaLayoutGuide.topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor)

		let namesContainer = UIView()
		let categoryContainer = UIView()
		let container = UIView()

		container.stack(namesContainer.stack(nameLabel, nameTF), categoryContainer.stack(categoryLabel, categoryTF))
		addSubview(container)
		container.anchor(top: mapView.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 10, left: 10, bottom: 0, right: 10))
	}
}
