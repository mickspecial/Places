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

	private func setUpView() {
		let sv = stack(.vertical, views: nameLabel, addressLabel).withMargins(.init(top: 10, left: 16, bottom: 10, right: 16))
		sv.distribution = .fillEqually
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
