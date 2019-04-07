//
//  PinCalloutView.swift
//  Places
//
//  Created by Michael Schembri on 8/4/19.
//  Copyright © 2019 Michael Schembri. All rights reserved.
//

import UIKit

class PinCalloutView: UIView {

	let titleLabel: UILabel = {
		let tf = UILabel()
		tf.text = "titleLabel"
		return tf
	}()

	let subLabel: UILabel = {
		let tf = UILabel()
		tf.text = "subLabel"
		return tf
	}()

	init(place: Place) {
		super.init(frame: .zero)
		setupView()
		titleLabel.text = place.name
		subLabel.text = place.details
	}

	override init(frame: CGRect) {
		super.init(frame: frame)
		setupView()
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setupView()
	}

	private func setupView() {
		let stackView = UIStackView(arrangedSubviews: [titleLabel, subLabel])
		stackView.axis = .vertical
		stackView.distribution = .fillEqually
		stackView.spacing = 10
		stackView.alignment = .center
		addSubview(stackView)
		stackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor)
	}
}
