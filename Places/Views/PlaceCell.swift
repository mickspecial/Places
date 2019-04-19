//
//  PlaceCell.swift
//  Places
//
//  Created by Michael Schembri on 8/4/19.
//  Copyright © 2019 Michael Schembri. All rights reserved.
//

import UIKit

protocol PlaceCellDelegate: AnyObject {
	func placeCellMapPressed(place: Place)
}

class PlaceCell: UICollectionViewCell {

	override init(frame: CGRect) {
		super.init(frame: frame)
		backgroundColor = Theme.current.cellDark
		layer.cornerRadius = 10
		setUpView()
	}

	override var isSelected: Bool {
		didSet {
			backgroundColor = isSelected ? .darkGray : Theme.current.cellDark
		}
	}

	private var	nameLabel = UILabel(text: "Name", font: .systemFont(ofSize: 16, weight: .bold), textColor: .white)
	private var	addressLabel = UILabel(text: "", font: .systemFont(ofSize: 10, weight: .bold), textColor: .white)

	let showOnMapBtn: UIButton = {
		let button = UIButton(type: .system)
		button.setImage(#imageLiteral(resourceName: "marker"), for: .normal)
		button.tintColor = Theme.current.highlight
		button.backgroundColor = .clear
		button.widthAnchor.constraint(equalToConstant: 80).isActive = true
		return button
	}()

	var markerImageView: UIImageView = {
		let logoView = UIImageView()
		logoView.image = #imageLiteral(resourceName: "white")
		logoView.contentMode = .scaleAspectFit
		logoView.heightAnchor.constraint(equalToConstant: 20).isActive = true
		logoView.widthAnchor.constraint(equalToConstant: 20).isActive = true
		return logoView
	}()

	private var place: Place?
	weak var delegate: PlaceCellDelegate?

	private func setUpView() {
		let stackview = UIStackView(arrangedSubviews: [
			markerImageView,
			VerticalStackView(arrangedSubviews: [nameLabel, addressLabel], spacing: 10),
			showOnMapBtn
		])

		nameLabel.allowsDefaultTighteningForTruncation = true

		stackview.alignment = .center
		stackview.spacing = 12
		addSubview(stackview)
		stackview.fillSuperview(padding: .init(top: 0, left: 16, bottom: 0, right: 0))
		showOnMapBtn.addTarget(self, action: #selector(showMapPressed), for: .touchUpInside)
	}

	@objc func showMapPressed() {
		if let place = place {
			delegate?.placeCellMapPressed(place: place)
		}
	}

	func fillCell(place: Place) {
		self.place = place
		nameLabel.text = place.name
		addressLabel.text = place.address
		markerImageView.image = place.markerImage
		addressLabel.isHidden = place.address.isEmpty
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
