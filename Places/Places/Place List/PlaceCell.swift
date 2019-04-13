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
		setUpView()
	}

	var nameLabel: UILabel = {
		let label = UILabel(frame: .zero)
		label.textColor = .white
		label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
		label.allowsDefaultTighteningForTruncation = true
		return label
	}()

	var addressLabel: UILabel = {
		let label = UILabel(frame: .zero)
		label.textColor = .white
		label.font = UIFont.systemFont(ofSize: 10, weight: .bold)
		return label
	}()

	let showOnMapBtn: UIButton = {
		let button = UIButton(type: .system)
		button.setImage(#imageLiteral(resourceName: "marker"), for: .normal)
		button.tintColor = Theme.current.highlight
		button.backgroundColor = .clear
		return button
	}()

	var markerImageView: UIImageView = {
		let logoView = UIImageView()
		logoView.image = #imageLiteral(resourceName: "white")
		logoView.contentMode = .scaleAspectFit
		return logoView
	}()

	private var place: Place?
	weak var delegate: PlaceCellDelegate?

	private func setUpView() {
		let theViews = [markerImageView, nameLabel, addressLabel, showOnMapBtn]
		theViews.forEach({ addSubview($0)})
		backgroundColor = Theme.current.cellDark
		markerImageView.anchor(top: nil, leading: leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 10, bottom: 0, right: 0), size: CGSize(width: 20, height: 20))
		markerImageView.centerY()
		nameLabel.anchor(top: topAnchor, leading: markerImageView.trailingAnchor, bottom: addressLabel.topAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 10, bottom: 0, right: 10))
		addressLabel.anchor(top: nameLabel.bottomAnchor, leading: markerImageView.trailingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 10, bottom: 10, right: 10))
		showOnMapBtn.anchor(top: topAnchor, leading: nil, bottom: bottomAnchor, trailing: trailingAnchor, size: .init(width: 80, height: 0))

		showOnMapBtn.addTarget(self, action: #selector(showMapPressed), for: .touchUpInside)

		layer.cornerRadius = 10
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
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
