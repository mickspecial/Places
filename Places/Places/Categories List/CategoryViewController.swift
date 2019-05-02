//
//  CategoryViewController.swift
//  Places
//
//  Created by Michael Schembri on 11/4/19.
//  Copyright © 2019 Michael Schembri. All rights reserved.
//

import UIKit

struct GroupedItem {
	let sectionTitle: String
	let cell = UITableViewCell()
	let textField: UITextField
	let marker: MarkerColor

	init(_ maker: MarkerColor) {
		self.textField = UITextField(frame: CGRect(x: 20, y: 0, width: cell.frame.width, height: cell.frame.height))
		self.textField.placeholder = "Custom Category Name"
		self.textField.textColor = .white
		cell.backgroundColor = Theme.current.cellDark
		self.cell.addSubview(textField)
		self.marker = maker
		switch maker {
		case .blue: self.sectionTitle = "Blue"
		case .red: self.sectionTitle = "Red"
		case .green: self.sectionTitle = "Green"
		case .orange: self.sectionTitle = "Orange"
		case .cyan: self.sectionTitle = "Cyan"
		case .white: self.sectionTitle = "White"
		case .purple: self.sectionTitle = "Purple"
		}
	}
}

class CategoryViewController: UITableViewController {

	let coordinator: PlaceListCoordinator
	var items = [GroupedItem]()
	private var exportButton: UIBarButtonItem?

	init(coordinator: PlaceListCoordinator) {
		self.coordinator = coordinator
		super.init(nibName: nil, bundle: nil)
	}

	override func loadView() {
		super.loadView()
		items = [
			GroupedItem(.cyan),
			GroupedItem(.blue),
			GroupedItem(.green),
			GroupedItem(.orange),
			GroupedItem(.red),
			GroupedItem(.purple),
			GroupedItem(.white)
		]
	}

	private func setUp(cell: UITableViewCell) -> UITextField {
		let tf = UITextField(frame: CGRect(x: 20, y: 0, width: cell.frame.width, height: cell.frame.height))
		tf.placeholder = "Custom Category Name"
		cell.addSubview(tf)
		return tf
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		title = "Settings"
		setUpTableView()
		fillCells()
		exportButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(exportData))
		navigationItem.rightBarButtonItem = exportButton
	}

	@objc func exportData() {

		saveCatagories()
		User.current.save()

		let encoder = JSONEncoder()
		encoder.dateEncodingStrategy = .iso8601

		if let encodedUser = try? encoder.encode(User.current!) {
			let dataseturl = exportToFileURL(data: encodedUser)
			let activityViewController = UIActivityViewController(activityItems: [dataseturl], applicationActivities: nil)

			if let popoverPresentationController = activityViewController.popoverPresentationController {
				popoverPresentationController.barButtonItem = exportButton
			}
			present(activityViewController, animated: true)
		}
	}

	private func exportToFileURL(data: Data) -> URL {

		guard let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
			fatalError()
		}

		let saveFileURL = path.appendingPathComponent("place_data.plcs")
		try! data.write(to: saveFileURL)
		return saveFileURL
	}

	private func setUpTableView() {
		tableView = UITableView(frame: view.frame, style: .grouped)
		tableView.delegate = self
		tableView.dataSource = self
		tableView.allowsSelection = false
		tableView.backgroundColor = Theme.current.primary
		tableView.separatorColor = Theme.current.primary
	}

	private func fillCells() {
		for item in items {
			item.textField.text = User.current.categories[item.marker]
		}
	}

	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		view.endEditing(true)
	}

	override func numberOfSections(in tableView: UITableView) -> Int {
		return items.count
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		return items[indexPath.section].cell // only one cell per section so can do this
	}

	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return items[section].sectionTitle
	}

	override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
		let header = view as! UITableViewHeaderFooterView
		header.textLabel?.textColor = .lightGray
		header.textLabel?.font = UIFont.systemFont(ofSize: 14, weight: .heavy)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func saveCatagories() {
		for item in items {
			save(item)
		}
	}

	override func viewWillDisappear(_ animated: Bool) {
		saveCatagories()
	}

	func save(_ item: GroupedItem) {
		// only save if name has been changed and is not empty string
		let isValidString = !item.textField.string.isEmpty
		let nameHasChanged = item.textField.string != User.current.categories[item.marker]
		if isValidString && nameHasChanged {
			print("Save \(item.textField.string) for \(item.marker)")
			User.current.updateCategory(colour: item.marker, value: item.textField.string)
		}
	}
}
