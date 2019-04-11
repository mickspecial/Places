//
//  FindTableViewController.swift
//  Places
//
//  Created by Michael Schembri on 7/4/19.
//  Copyright © 2019 Michael Schembri. All rights reserved.
//

import UIKit
import MapKit

// swiftlint:disable line_length

class FindTableViewController: UITableViewController {

	lazy private var searchController: UISearchController = {
		var sctrl = UISearchController()
		sctrl = UISearchController(searchResultsController: nil)
		sctrl.obscuresBackgroundDuringPresentation = false
		sctrl.searchBar.placeholder = "Find Place"
		sctrl.hidesNavigationBarDuringPresentation = false
		sctrl.searchResultsUpdater = self
		sctrl.searchBar.delegate = self
		return sctrl
	}()

	lazy private var searchCompleter: MKLocalSearchCompleter = {
		let searchCompleter = MKLocalSearchCompleter()
		searchCompleter.delegate = self
		return searchCompleter
	}()

	private var searchResults = [MKLocalSearchCompletion]()
	let placesController: PlacesController
	let coordinator: FindCoordinator

	init(placesCtrl: PlacesController, coordinator: FindCoordinator) {
		placesController = placesCtrl
		self.coordinator = coordinator
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

    override func viewDidLoad() {
        super.viewDidLoad()
		setUpNavBar()
		tableView.backgroundColor = Theme.current.primary
    }

	private func setUpNavBar() {
		title = "Add Location"
		definesPresentationContext = true
		navigationItem.hidesBackButton = false
		navigationItem.searchController = searchController
		navigationItem.hidesSearchBarWhenScrolling = false
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		searchController.searchBar.becomeFirstResponder()
	}

	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return searchResults.count
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let searchResult = searchResults[indexPath.row]
		let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
		cell.textLabel?.textColor = .white
		cell.detailTextLabel?.textColor = .white
		cell.backgroundColor = Theme.current.cellDark
		// show search letters in bold
		cell.textLabel?.attributedText = NSAttributedString.highlightedText(searchResult.title, ranges: searchResult.titleHighlightRanges, size: 17)
		cell.detailTextLabel?.attributedText = NSAttributedString.highlightedText(searchResult.subtitle, ranges: searchResult.subtitleHighlightRanges, size: 12)
		return cell
	}

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		let completion = searchResults[indexPath.row]

		let searchRequest = MKLocalSearch.Request(completion: completion)
		let search = MKLocalSearch(request: searchRequest)
		search.start { [weak self] (response, _) in
			guard let response = response, let item = response.mapItems.first else {
				SCLAlertView(appearance: AlertService.standard).showError("Missing coordinate")
				return
			}

			DispatchQueue.main.async { [weak self] in
				self?.coordinator.showDetails(item)
			}
		}
	}
}

extension FindTableViewController: UISearchBarDelegate {
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		searchCompleter.queryFragment = searchText
	}
}

extension FindTableViewController: MKLocalSearchCompleterDelegate {
	func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
		searchResults = completer.results
		tableView.reloadData()
	}
}

extension FindTableViewController: UISearchResultsUpdating {
	func updateSearchResults(for searchController: UISearchController) {
		let text = searchController.searchBar.text ?? ""
		if text.isEmpty {
			searchResults.removeAll()
			tableView.reloadData()
		}
	}
}
