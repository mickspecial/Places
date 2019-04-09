//
//  PlaceCell.swift
//  Places
//
//  Created by Michael Schembri on 8/4/19.
//  Copyright © 2019 Michael Schembri. All rights reserved.
//

import UIKit

class PlaceCell: UICollectionViewCell {

	override init(frame: CGRect) {
		super.init(frame: frame)
		setUpView()
	}

	var nameLabel: UILabel = {
		let label = UILabel(frame: .zero)
		label.textColor = .black
		label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
		label.allowsDefaultTighteningForTruncation = true
		return label
	}()

	var addressLabel: UILabel = {
		let label = UILabel(frame: .zero)
		label.textColor = .darkGray
		label.font = UIFont.systemFont(ofSize: 10, weight: .bold)
		return label
	}()

	private func setUpView() {
		let theViews = [nameLabel, addressLabel]
		theViews.forEach({ addSubview($0)})
		backgroundColor = .lightGray
		nameLabel.anchor(top: topAnchor, leading: leadingAnchor, bottom: addressLabel.topAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 10, bottom: 0, right: 10))
		addressLabel.anchor(top: nameLabel.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 10, bottom: 10, right: 10))
	}

	func fillCell(info: Place) {
		nameLabel.text = info.name
		addressLabel.text = info.address
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
