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
		navigationItem.searchController = sctrl
		navigationItem.hidesSearchBarWhenScrolling = false
		sctrl.searchBar.delegate = self
		definesPresentationContext = true
		sctrl.searchResultsUpdater = self
		return sctrl
	}()

	var searchCompleter = MKLocalSearchCompleter()
	var searchResults = [MKLocalSearchCompletion]()

    override func viewDidLoad() {
        super.viewDidLoad()
		title = "Add Location"
		searchCompleter.delegate = self
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
		cell.textLabel?.attributedText = highlightedText(searchResult.title, inRanges: searchResult.titleHighlightRanges, size: 17.0)
		cell.detailTextLabel?.attributedText = highlightedText(searchResult.subtitle, inRanges: searchResult.subtitleHighlightRanges, size: 12.0)
		return cell
	}

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		let completion = searchResults[indexPath.row]

		let searchRequest = MKLocalSearch.Request(completion: completion)
		let search = MKLocalSearch(request: searchRequest)
		search.start { (response, _) in
			guard let response = response, let item = response.mapItems.first else {
				print("Missing coordinate")
				return
			}
			let coordinate = item.placemark.coordinate
			print(String(describing: coordinate))
		}
	}

	/**
	Highlights the matching search strings with the results
	- parameter text: The text to highlight
	- parameter ranges: The ranges where the text should be highlighted
	- parameter size: The size the text should be set at
	- returns: A highlighted attributed string with the ranges highlighted
	*/
	func highlightedText(_ text: String, inRanges ranges: [NSValue], size: CGFloat) -> NSAttributedString {
		let attributedText = NSMutableAttributedString(string: text)
		let regular = UIFont.systemFont(ofSize: size)
		let range = NSRange(location: 0, length: text.count)
		attributedText.addAttribute(NSAttributedString.Key.font, value: regular, range: range)
		let bold = UIFont.boldSystemFont(ofSize: size)
		for value in ranges {
			attributedText.addAttribute(NSAttributedString.Key.font, value: bold, range: value.rangeValue)
		}
		return attributedText
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
