//
//  FindCell.swift
//  Places
//
//  Created by Michael Schembri on 15/4/19.
//  Copyright © 2019 Michael Schembri. All rights reserved.
//

import UIKit
import MapKit

class SearchCell: UICollectionViewCell {

	override init(frame: CGRect) {
		super.init(frame: frame)
		backgroundColor = Theme.current.cellDark
		layer.cornerRadius = 10
		setUpView()
	}

	override var isSelected: Bool {
		didSet {
			if self.isSelected {
				backgroundColor = .darkGray
			} else {
				backgroundColor = Theme.current.cellDark
			}
		}
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

	private func setUpView() {

		let labelsStackView = UIStackView(arrangedSubviews: [
			nameLabel, addressLabel
		])

		labelsStackView.axis = .vertical
		labelsStackView.spacing = 10

		let stackview = UIStackView(arrangedSubviews: [
			labelsStackView
		])

		stackview.alignment = .center
		stackview.spacing = 8
		addSubview(stackview)
		stackview.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 16, bottom: 0, right: 16))
	}

	func fillCell(_ searchResult: MKLocalSearchCompletion) {
		nameLabel.attributedText = NSAttributedString.highlightedText(searchResult.title, ranges: searchResult.titleHighlightRanges, size: 17)
		addressLabel.attributedText = NSAttributedString.highlightedText(searchResult.subtitle, ranges: searchResult.subtitleHighlightRanges, size: 12)
		addressLabel.isHidden = searchResult.subtitle.isEmpty
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
