//
//  FindTableViewController.swift
//  Places
//
//  Created by Michael Schembri on 7/4/19.
//  Copyright © 2019 Michael Schembri. All rights reserved.
//

import UIKit
import MapKit

class FindListController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

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
	private let cellId = "cellId"

	init(placesCtrl: PlacesController, coordinator: FindCoordinator) {
		self.placesController = placesCtrl
		self.coordinator = coordinator
		let layout = UICollectionViewFlowLayout()
		layout.scrollDirection = .vertical
		super.init(collectionViewLayout: layout)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		setUpNavBar()
		collectionView.backgroundColor = Theme.current.primary
		collectionView.register(SearchCell.self, forCellWithReuseIdentifier: cellId)
		collectionView.dataSource = self
		collectionView.delegate = self
		collectionView.contentInset = .init(top: 10, left: 0, bottom: 10, right: 0)
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
		//searchController.searchBar.becomeFirstResponder()
	}

	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return searchResults.count
	}

	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		collectionView.deselectItem(at: indexPath, animated: true)
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SearchCell
		let searchResult = searchResults[indexPath.row]
		// show search letters in bold
		cell.nameLabel.attributedText = NSAttributedString.highlightedText(searchResult.title, ranges: searchResult.titleHighlightRanges, size: 17)
		cell.addressLabel.attributedText = NSAttributedString.highlightedText(searchResult.subtitle, ranges: searchResult.subtitleHighlightRanges, size: 12)
		return cell
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return 10
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: view.frame.width - 20, height: 60)
	}

	override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
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

extension FindListController: UISearchBarDelegate {
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		searchCompleter.queryFragment = searchText
	}
}

extension FindListController: MKLocalSearchCompleterDelegate {
	func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
		searchResults = completer.results
		collectionView.reloadData()
	}
}

extension FindListController: UISearchResultsUpdating {
	func updateSearchResults(for searchController: UISearchController) {
		let text = searchController.searchBar.text ?? ""
		if text.isEmpty {
			searchResults.removeAll()
			collectionView.reloadData()
		}
	}
}
