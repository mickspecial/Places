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

	let cyanCell = UITableViewCell()
	let greenCell = UITableViewCell()
	let orangeCell = UITableViewCell()
	let blueCell = UITableViewCell()
	let purpleCell = UITableViewCell()
	let redCell = UITableViewCell()
	let whiteCell = UITableViewCell()

	var cyanCellText: UITextField!
	var greenCellText: UITextField!
	var orangeCellText: UITextField!
	var blueCellText: UITextField!
	var purpleCellText: UITextField!
	var redCellText: UITextField!
	var whiteCellText: UITextField!

	private var cells = [UITableViewCell]()
	private var textFields = [UITextField]()
	private var labels = [String]()
	private var markers = [MarkerColor]()

	init(categoryCtrl: CategoryController, coordinator: HomeCoordinator) {
		self.categoryCtrl = categoryCtrl
		self.coordinator = coordinator
		super.init(nibName: nil, bundle: nil)
	}

	override func loadView() {
		super.loadView()
		// construct first name cell, section 0, row 0
		blueCellText = setUp(cell: blueCell)
		redCellText = setUp(cell: redCell)
		cyanCellText = setUp(cell: cyanCell)
		greenCellText = setUp(cell: greenCell)
		orangeCellText = setUp(cell: orangeCell)
		purpleCellText = setUp(cell: purpleCell)
		whiteCellText = setUp(cell: whiteCell)

		// set up data arrays
		cells = [cyanCell, greenCell, orangeCell, blueCell, purpleCell, redCell, whiteCell]
		textFields = [cyanCellText, greenCellText, orangeCellText, blueCellText, purpleCellText, redCellText, whiteCellText]
		labels = ["Cyan", "Green", "Orange", "Blue", "Purple", "Red", "White"]
		markers = [.cyan, .green, .orange, .blue, .purple, .red, .white]
		assert(cells.count == labels.count && labels.count == markers.count && labels.count == textFields.count)
	}

	private func setUp(cell: UITableViewCell) -> UITextField {
		let tf = UITextField(frame: CGRect(x: 20, y: 0, width: cell.frame.width, height: cell.frame.height))
		tf.placeholder = "Custom Category Name"
		cell.addSubview(tf)
		return tf
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		title = "Categories"
		setUpTableView()
		fillCells()
	}

	private func setUpTableView() {
		tableView = UITableView(frame: view.frame, style: .grouped)
		tableView.delegate = self
		tableView.dataSource = self
		tableView.allowsSelection = false
	}

	private func fillCells() {
		for index in 0..<markers.count {
			let currentMarker = markers[index]
			let currentTextField = textFields[index]
			currentTextField.text = categoryCtrl.categories[currentMarker]
		}
	}

	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		view.endEditing(true)
	}

	override func numberOfSections(in tableView: UITableView) -> Int {
		return cells.count
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		return cells[indexPath.section] // only one cell per section so can do this
	}

	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return labels[section]
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewWillDisappear(_ animated: Bool) {
		// save as necessary
		for index in 0..<markers.count {
			save(textField: textFields[index], marker: markers[index])
		}
	}

	func save(textField: UITextField, marker: MarkerColor) {
		// only save if name has been changed and is not empty string
		let isValidString = !textField.string.isEmpty
		let nameHasChanged = textField.string != categoryCtrl.categories[marker]
		if isValidString && nameHasChanged {
			print("Save \(textField.string) for \(marker)")
			categoryCtrl.categories[marker] = textField.string
		}
	}
}
