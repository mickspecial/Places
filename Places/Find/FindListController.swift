//
//  FindTableViewController.swift
//  Places
//
//  Created by Michael Schembri on 7/4/19.
//  Copyright © 2019 Michael Schembri. All rights reserved.
//

import UIKit
import MapKit
import Lottie

class FindListController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

	lazy private var searchController: UISearchController = {
		var sctrl = UISearchController()
		sctrl = UISearchController(searchResultsController: nil)
		sctrl.obscuresBackgroundDuringPresentation = false
		sctrl.searchBar.placeholder = "Find Place"
		sctrl.hidesNavigationBarDuringPresentation = false
		sctrl.searchResultsUpdater = self
		sctrl.searchBar.delegate = self
		sctrl.dimsBackgroundDuringPresentation = false
		return sctrl
	}()

	var searchLabel = UILabel(text: "Search for location above", font: .systemFont(ofSize: 20), textColor: Theme.current.highlight)
	let markerAnimation = AnimationView(name: "markerAnimation")

	lazy private var searchCompleter: MKLocalSearchCompleter = {
		let searchCompleter = MKLocalSearchCompleter()
		searchCompleter.delegate = self
		return searchCompleter
	}()

	private var searchResults = [MKLocalSearchCompletion]()
	let coordinator: FindCoordinator
	private let cellId = "cellId"

	init(coordinator: FindCoordinator) {
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
		view.addSubview(searchLabel)
		searchLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 30, left: 0, bottom: 0, right: 0))
		searchLabel.centerXInSuperview()
		searchLabel.textAlignment = .center
		let tappableView = UIView(frame: collectionView.bounds)
		collectionView.backgroundView = tappableView
		collectionView.backgroundView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapDismiss)))
		setUpMarkerAnimation()
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		searchController.searchBar.becomeFirstResponder()
	}

	func setUpMarkerAnimation() {
		markerAnimation.loopMode = .loop
		view.addSubview(markerAnimation)
		markerAnimation.anchor(top: searchLabel.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: CGSize(width: 200, height: 150))
		markerAnimation.centerXInSuperview()
		markerAnimation.play()
	}

	@objc func tapDismiss() {
		searchController.searchBar.endEditing(true)
	}

	private func setUpNavBar() {
		title = "Add Location"
		definesPresentationContext = true
		// fixed the resizing of my view after popping the details view
		extendedLayoutIncludesOpaqueBars = true
		navigationItem.hidesBackButton = false
		navigationItem.searchController = searchController
		navigationItem.hidesSearchBarWhenScrolling = false
	}

	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		searchLabel.isHidden = !searchResults.isEmpty
		markerAnimation.isHidden = !searchResults.isEmpty
		return searchResults.count
	}

	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		collectionView.deselectItem(at: indexPath, animated: true)
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SearchCell
		cell.fillCell(searchResults[indexPath.row])
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
//				self?.searchController.searchBar.text = ""
			}
		}
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
		return .init(top: 10, left: 0, bottom: 10, right: 0)
	}

	private func updateTitle() {
		title = searchCompleter.isSearching ? "Add Location ⏳" : "Add Location"
	}
}

extension FindListController: UISearchBarDelegate {
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		if let text = searchBar.text, text.isEmpty {
			searchCompleter.cancel()
		} else {
			searchCompleter.queryFragment = searchText
		}
		updateTitle()
	}
}

extension FindListController: MKLocalSearchCompleterDelegate {
	func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
		searchResults = completer.results
		collectionView.reloadData()
		updateTitle()
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
