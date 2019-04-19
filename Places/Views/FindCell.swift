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
			backgroundColor = isSelected ? .darkGray : Theme.current.cellDark
		}
	}

	private var	nameLabel = UILabel(text: "Name", font: .systemFont(ofSize: 16, weight: .bold), textColor: .white)
	private var	addressLabel = UILabel(text: "", font: .systemFont(ofSize: 10, weight: .bold), textColor: .white)

	private func setUpView() {

		let stackview = UIStackView(arrangedSubviews: [
			VerticalStackView(arrangedSubviews: [nameLabel, addressLabel], spacing: 10)
		])

		nameLabel.allowsDefaultTighteningForTruncation = true

		stackview.alignment = .center
		stackview.spacing = 8
		addSubview(stackview)
		stackview.fillSuperview(padding: .init(top: 0, left: 16, bottom: 0, right: 16))
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
