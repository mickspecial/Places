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

	let start: UIButton = {
		let button = UIButton(type: .system)
		button.setTitle("Start", for: .normal)
		button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
		button.setTitleColor(.white, for: .normal)
		button.backgroundColor = UIColor.FlatColor.Green.Fern
		button.tag = ButtonTag.start.rawValue
		return button
	}()

	var startLabel: UILabel = {
		let label = UILabel(frame: .zero)
		label.textColor = .white
		label.font = UIFont.systemFont(ofSize: 13, weight: .bold)
		return label
	}()

	var endLabel: UILabel = {
		let label = UILabel(frame: .zero)
		label.textColor = .white
		label.font = UIFont.systemFont(ofSize: 13, weight: .bold)
		return label
	}()

	enum ButtonTag: Int {
		case start, end
	}

	let end: UIButton = {
		let button = UIButton(type: .system)
		button.setTitle("End", for: .normal)
		button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
		button.setTitleColor(.white, for: .normal)
		button.backgroundColor = UIColor.FlatColor.Red.TerraCotta
		button.tag = ButtonTag.end.rawValue
		return button
	}()

	weak var delegate: StartEndViewControllerDelegate?

	override func viewDidLoad() {
		super.viewDidLoad()
		addToFromButtons()
		precondition(delegate != nil)
	}

	private func addToFromButtons() {
		view.addSubview(start)
		view.addSubview(end)
		view.addSubview(startLabel)
		view.addSubview(endLabel)
		start.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, size: .init(width: 80, height: 40))
		end.anchor(top: nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: nil, size: .init(width: 80, height: 40))

		end.addTarget(self, action: #selector(startEndButtonTapped), for: .touchUpInside)
		start.addTarget(self, action: #selector(startEndButtonTapped), for: .touchUpInside)

		startLabel.anchor(top: start.topAnchor, leading: start.trailingAnchor, bottom: start.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 10, bottom: 0, right: 0))
		endLabel.anchor(top: end.topAnchor, leading: end.trailingAnchor, bottom: end.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 10, bottom: 0, right: 0))
	}

	@objc func startEndButtonTapped(sender: UIButton) {
		guard let tag = ButtonTag(rawValue: sender.tag) else { fatalError() }
		delegate?.startEndWasTapped(button: tag)
	}
}
