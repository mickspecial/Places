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

	override var isHighlighted: Bool {
		didSet {
			let tf: CGAffineTransform = isHighlighted ? .init(scaleX: 0.95, y: 0.95) : .identity
			UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
				self.transform = tf
			}, completion: nil)
		}
	}

	private var	nameLabel = UILabel(text: "Name", font: .systemFont(ofSize: 16, weight: .bold), textColor: .white)
	private var	addressLabel = UILabel(text: "", font: .systemFont(ofSize: 10, weight: .bold), textColor: .white)

	let showOnMapBtn: UIButton = {
		let button = UIButton(type: .system)
		button.setImage(#imageLiteral(resourceName: "marker"), for: .normal)
		button.tintColor = Theme.current.highlight
		button.backgroundColor = .clear
		button.constrainWidth(constant: 80)
		return button
	}()

	var markerImageView: UIImageView = {
		let logoView = UIImageView()
		logoView.image = #imageLiteral(resourceName: "white")
		logoView.contentMode = .scaleAspectFit
		logoView.constrainHeight(constant: 20)
		logoView.constrainWidth(constant: 20)
		return logoView
	}()

	private var place: Place?
	weak var delegate: PlaceCellDelegate?

	private func setUpView() {
		let sv = stack(.horizontal, views: markerImageView, stack(views: nameLabel, addressLabel, spacing: 10), showOnMapBtn, spacing: 12)
		sv.alignment = .center
		sv.padLeft(16)
		nameLabel.allowsDefaultTighteningForTruncation = true
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
