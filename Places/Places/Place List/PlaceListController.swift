//
//  HomeViewController.swift
//  Places
//
//  Created by Michael Schembri on 7/4/19.
//  Copyright © 2019 Michael Schembri. All rights reserved.
//

import UIKit

class PlaceListController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

	let coordinator: PlaceListCoordinator
	private let cellId = "cellId"
	private var places = [Place]()

	init(coordinator: PlaceListCoordinator) {
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
		view.backgroundColor = Theme.current.primary

		title = "Places"
		collectionView.register(PlaceCell.self, forCellWithReuseIdentifier: cellId)
		collectionView.dataSource = self
		collectionView.delegate = self
		navigationItem.leftBarButtonItem = UIBarButtonItem.menuButton(self, action: #selector(showCategoriesView), imageName: "bullets", size: .large)
    }

	@objc func showCategoriesView() {
		coordinator.showCategories()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		prepareData()
	}

	func prepareData() {
		places = User.current.places.filter({ $0.isDeleted == false })
		places.sort(by: { $0.name.lowercased() < $1.name.lowercased() })
		collectionView.reloadData()
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

	var startingFrame: CGRect?

	override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		collectionView.deselectItem(at: indexPath, animated: true)

		// set starting frame
		guard let cell = collectionView.cellForItem(at: indexPath) else { return }
		// guard let fullScreen = cell.superview?.convert(cell.frame, to: nil) else { return }
		self.startingFrame = cell.frame

		// add cell
		let redCell = UIView()
		redCell.frame = cell.frame
		redCell.backgroundColor = .red
		redCell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cellWasTapped)))
		view.addSubview(redCell)

		UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
			redCell.frame = self.collectionView.frame
			self.tabBarController?.tabBar.transform = CGAffineTransform(translationX: 0, y: 100)
		}, completion: { _ in
			print("Animation Ended")
		})

		//let place = places[indexPath.row]
		//coordinator.showDetails(place)
	}

	@objc func cellWasTapped(gesture: UITapGestureRecognizer) {
		guard let startingPoint = self.startingFrame, let view = gesture.view else { return }
		UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
			view.frame = startingPoint
			self.tabBarController?.tabBar.transform = .identity
		}, completion: { _ in
			view.removeFromSuperview()
		})
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
		return .init(top: 10, left: 0, bottom: 10, right: 0)
	}
}

extension PlaceListController: PlaceCellDelegate {
	func placeCellMapPressed(place: Place) {
		coordinator.showOnMap(place)
	}
}
