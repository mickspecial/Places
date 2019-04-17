//
//  HomeViewController.swift
//  Places
//
//  Created by Michael Schembri on 7/4/19.
//  Copyright © 2019 Michael Schembri. All rights reserved.
//

import UIKit

class PlaceListController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

	let placesController: PlacesController
	let coordinator: PlaceListCoordinator
	private let cellId = "cellId"
	private var places = [Place]()

	init(placesCtrl: PlacesController, coordinator: PlaceListCoordinator) {
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
		collectionView.backgroundColor = Theme.current.primary
		title = "Places"
		collectionView.register(PlaceCell.self, forCellWithReuseIdentifier: cellId)
		collectionView.dataSource = self
		collectionView.delegate = self
		collectionView.contentInset = .init(top: 10, left: 0, bottom: 10, right: 0)
		navigationItem.rightBarButtonItem = UIBarButtonItem.menuButton(self, action: #selector(showCategoriesView), imageName: "bullets", size: .large)
    }

	@objc func showCategoriesView() {
		coordinator.showCategories()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		prepareData()
		collectionView.reloadData()
	}

	private func prepareData() {
		places = User.current.places.filter({ $0.isDeleted == false })
		places.sort(by: { $0.name.lowercased() < $1.name.lowercased() })
	}

	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return places.count
	}

	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! PlaceCell
		let place = places[indexPath.row]
		cell.fillCell(place: place)
		cell.delegate = self
		return cell
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return 10
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: view.frame.width - 20, height: 60)
	}

	override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		collectionView.deselectItem(at: indexPath, animated: true)
		let place = places[indexPath.row]
		coordinator.showDetails(place)
	}
}

extension PlaceListController: PlaceCellDelegate {
	func placeCellMapPressed(place: Place) {
		coordinator.showOnMap(place)
	}
}
