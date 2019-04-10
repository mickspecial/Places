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
	let placesController: PlacesController!
	let categoriesController: CategoryController!

	init(placesCtrl: PlacesController, categoriesCtrl: CategoryController) {
		placesController = placesCtrl
		categoriesController = categoriesCtrl
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

    override func viewDidLoad() {
        super.viewDidLoad()
		setUpNavBar()
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
				print("Missing coordinate")
				return
			}

			DispatchQueue.main.async { [weak self] in
				self?.promptForPlaceName(mapItem: item)
			}
		}
	}

	func promptForPlaceName(mapItem: MKMapItem) {
		let ac = UIAlertController(title: "Save Place As", message: nil, preferredStyle: .alert)
		ac.addTextField()
		ac.addAction(markerAction(.blue, mapItem: mapItem, alertController: ac))
		ac.addAction(markerAction(.red, mapItem: mapItem, alertController: ac))
		ac.addAction(markerAction(.green, mapItem: mapItem, alertController: ac))
		ac.addAction(markerAction(.cyan, mapItem: mapItem, alertController: ac))
		ac.addAction(markerAction(.orange, mapItem: mapItem, alertController: ac))
		ac.addAction(markerAction(.purple, mapItem: mapItem, alertController: ac))
		ac.addAction(markerAction(.white, mapItem: mapItem, alertController: ac))
		ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
		present(ac, animated: true)
	}

	private func titleForMarker(_ marker: MarkerColor) -> String {
		return categoriesController.categories[marker] ?? ""
	}

	private func markerAction(_ marker: MarkerColor, mapItem: MKMapItem, alertController: UIAlertController) -> UIAlertAction {
		let action = UIAlertAction(title: titleForMarker(marker), style: .default) { [weak self] _ in
			guard let tf = alertController.textFields?.first, !tf.string.isEmpty else {
				self?.alertError()
				return
			}
			self?.savePlaceWith(mapItem: mapItem, marker: marker, name: tf.string)
		}
		return action
	}

	func alertError() {
		let ac = UIAlertController(title: "Not Saved", message: "Missing Title", preferredStyle: .alert)
		ac.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
		present(ac, animated: true)
	}

	func savePlaceWith(mapItem: MKMapItem, marker: MarkerColor, name: String) {
		let newPlace = Place(mapItem: mapItem, name: name, category: marker)
		placesController.addPlace(newPlace)
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
