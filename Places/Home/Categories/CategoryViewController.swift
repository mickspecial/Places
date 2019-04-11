//
//  CategoryViewController.swift
//  Places
//
//  Created by Michael Schembri on 11/4/19.
//  Copyright © 2019 Michael Schembri. All rights reserved.
//

import UIKit

class CategoryViewController: UITableViewController {

	let coordinator: HomeCoordinator
	let categoryCtrl: CategoryController

	let blueCell = UITableViewCell()
	let redCell = UITableViewCell()

	var blueCellText: UITextField!
	var redCellText: UITextField!

	init(categoryCtrl: CategoryController, coordinator: HomeCoordinator) {
		self.categoryCtrl = categoryCtrl
		self.coordinator = coordinator
		super.init(nibName: nil, bundle: nil)
	}

	override func loadView() {
		super.loadView()
		// construct first name cell, section 0, row 0
		blueCellText = UITextField(frame: CGRect(x: 20, y: 0, width: blueCell.frame.width, height: blueCell.frame.height))
		blueCell.addSubview(blueCellText)

		redCellText = UITextField(frame: CGRect(x: 20, y: 0, width: redCell.frame.width, height: redCell.frame.height))
		redCell.addSubview(redCellText)

		[redCellText, blueCellText].forEach { tf in
			tf.placeholder = "Custom Category Name"
		}
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		tableView = UITableView(frame: view.frame, style: .grouped)
		view.backgroundColor = .groupTableViewBackground
		title = "Categories"
		tableView.delegate = self
		tableView.dataSource = self
		tableView.allowsSelection = false

		blueCellText.text = categoryCtrl.categories[.blue]
		redCellText.text = categoryCtrl.categories[.red]

	}

	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		view.endEditing(true)
	}

	override func numberOfSections(in tableView: UITableView) -> Int {
		return 2
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		switch section {
		case 0: return 1    // section 0 has 1 rows
		case 1: return 1    // section 1 has 1 row
		default: fatalError("Unknown number of sections")
		}
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

		switch indexPath.section {
		case 0:
			switch indexPath.row {
			case 0: return blueCell   // section 0, row 0 is the blue
			default: fatalError("Unknown row in section 0")
			}
		case 1:
			switch indexPath.row {
			case 0: return redCell      // section 1, row 0 is red
			default: fatalError("Unknown row in section 1")
			}
		default: fatalError("Unknown section")
		}
	}

	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		switch section {
		case 0: return "Blue Icon"
		case 1: return "Red Icon"
		default: fatalError("Unknown section")
		}
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewWillDisappear(_ animated: Bool) {
		save(textField: blueCellText, marker: .blue)
		save(textField: redCellText, marker: .red)
	}

	func save(textField: UITextField, marker: MarkerColor) {
		let isValidString = !textField.string.isEmpty
		let nameHasChanged = textField.string != categoryCtrl.categories[marker]
		if isValidString && nameHasChanged {
			print("Save \(textField.string) for \(marker)")
			categoryCtrl.categories[marker] = textField.string
		}
	}

}
