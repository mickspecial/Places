//
//  VerticalStackView.swift
//  Places
//
//  Created by Michael Schembri on 19/4/19.
//  Copyright © 2019 Michael Schembri. All rights reserved.
//

import UIKit

class VerticalStackView: UIStackView {

	init(arrangedSubviews: [UIView], spacing: CGFloat = 0) {
		super.init(frame: .zero)
		arrangedSubviews.forEach { view in
			addArrangedSubview(view)
		}
		self.axis = .vertical
		self.spacing = spacing
	}

	required init(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
