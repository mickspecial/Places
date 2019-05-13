//
//  StartEndViewController.swift
//  Places
//
//  Created by Michael Schembri on 13/4/19.
//  Copyright © 2019 Michael Schembri. All rights reserved.
//

import UIKit

protocol StartEndViewControllerDelegate: AnyObject {
	func startEndWasTapped(button: StartEndViewController.ButtonTag)
}

class StartEndViewController: UIViewController {

	let start = UIButton(title: "Start", titleColor: .white, font: UIFont.boldSystemFont(ofSize: 14), target: self, action: #selector(startEndButtonTapped))
	let end = UIButton(title: "End", titleColor: .white, font: UIFont.boldSystemFont(ofSize: 14), target: self, action: #selector(startEndButtonTapped))
	var startLabel = UILabel(text: "", font: .boldSystemFont(ofSize: 13), textColor: .white)
	var endLabel = UILabel(text: "", font: .boldSystemFont(ofSize: 13), textColor: .white)

	enum ButtonTag: Int {
		case start, end
	}

	weak var delegate: StartEndViewControllerDelegate?

	override func viewDidLoad() {
		super.viewDidLoad()
		addToFromButtons()
		precondition(delegate != nil)
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		convertButtonToPill(end, color: UIColor.FlatColor.Red.TerraCotta)
		convertButtonToPill(start, color: UIColor.FlatColor.Green.Fern)
	}

	private func convertButtonToPill(_ button: UIButton, color: UIColor) {
		let shapeLayer = CAShapeLayer()
		shapeLayer.path = UIBezierPath(roundedRect: button.layer.bounds.insetBy(dx: 10, dy: 6), cornerRadius: 12).cgPath
		shapeLayer.fillColor = color.cgColor
		button.layer.insertSublayer(shapeLayer, at: 0)
		shapeLayer.frame = button.bounds
	}

	private func addToFromButtons() {
		start.tag = ButtonTag.start.rawValue
		end.tag = ButtonTag.end.rawValue

		view.addSubviews(start, end, startLabel, endLabel)
		start.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, size: .init(width: 80, height: 40))
		end.anchor(top: nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: nil, size: .init(width: 80, height: 40))
		startLabel.anchor(top: start.topAnchor, leading: start.trailingAnchor, bottom: start.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 10, bottom: 0, right: 0))
		endLabel.anchor(top: end.topAnchor, leading: end.trailingAnchor, bottom: end.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 10, bottom: 0, right: 0))
	}

	@objc func startEndButtonTapped(sender: UIButton) {
		guard let tag = ButtonTag(rawValue: sender.tag) else { fatalError() }
		delegate?.startEndWasTapped(button: tag)
	}
}
