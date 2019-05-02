//
//  HomeViewController.swift
//  Places
//
//  Created by Michael Schembri on 7/4/19.
//  Copyright © 2019 Michael Schembri. All rights reserved.
//

import UIKit
import Lottie

extension PlaceListController: PlaceDetailsViewControllerDelegate {
	func dismissChildViewController() {
		dismissAnimateFromScreen()
	}
}

class PlaceListController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

	let coordinator: PlaceListCoordinator
	private let cellId = "cellId"
	private var places = [Place]() {
		didSet {
			addLabel.isHidden = !places.isEmpty
			markerAnimation.isHidden = !places.isEmpty
		}
	}

	var addLabel = UILabel(text: "Add locations in seach tab", font: .systemFont(ofSize: 20), textColor: Theme.current.highlight)
	let markerAnimation = AnimationView(name: "place")

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
		addInfoToBackground()
    }

	func addInfoToBackground() {
		view.addSubview(addLabel)
		addLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 30, left: 0, bottom: 0, right: 0))
		addLabel.centerXInSuperview()
		addLabel.textAlignment = .center

		markerAnimation.loopMode = .loop
		view.addSubview(markerAnimation)
		markerAnimation.anchor(top: addLabel.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 10, left: 0, bottom: 0, right: 0), size: CGSize(width: 200, height: 120))
		markerAnimation.centerXInSuperview()
		markerAnimation.play()
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

	var childVC: PlaceDetailsViewController?
	var startingFrame: CGRect?
	var topCons: NSLayoutConstraint?
	var leadCons: NSLayoutConstraint?
	var widthCons: NSLayoutConstraint?
	var heightCons: NSLayoutConstraint?

	override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		collectionView.deselectItem(at: indexPath, animated: true)
		showDetailsVC(indexPath)
	}

	func showDetailsVC(_ indexPath: IndexPath) {
		setUpDetailsVCScreen(indexPath)
		setUpDetailsStartingPostition(indexPath)
		animateToScreen()
	}

	func setUpDetailsVCScreen(_ indexPath: IndexPath) {
		let place = places[indexPath.row]
		childVC = coordinator.showDetailsVC(place)
		childVC?.delegate = self
		childVC?.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissAnimateFromScreen)))
	}

	var anchoredConstraints: AnchoredConstraints?

	func setUpDetailsStartingPostition(_ indexPath: IndexPath) {
		guard let cell = collectionView.cellForItem(at: indexPath), let childVC = childVC, let sv = view.superview else { return }
		addChildToVC(childVC)
		startingFrame = cell.frame
		anchoredConstraints = childVC.view.anchor(top: sv.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: startingFrame!.origin.y, left: startingFrame!.origin.x, bottom: 0, right: 0), size: .init(width: startingFrame!.width, height: startingFrame!.height))
		view.layoutIfNeeded()
	}

	func animateToScreen() {
		UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
			self.anchoredConstraints?.top?.constant = 0
			self.anchoredConstraints?.leading?.constant = 0
			self.anchoredConstraints?.height?.constant = self.view.superview?.frame.height ?? 0
			self.anchoredConstraints?.width?.constant = self.view.frame.width
			self.view.layoutIfNeeded()
			self.tabBarController?.tabBar.transform = CGAffineTransform(translationX: 0, y: 100)
			self.navigationController?.navigationBar.transform = CGAffineTransform(translationX: 0, y: -200)
		}, completion: nil)
	}

	@objc func dismissAnimateFromScreen() {
		guard let startingPoint = self.startingFrame else { return }
		guard let vc = self.childVC, vc.canBeDismissed else { return }

		navigationController?.navigationBar.isHidden = false
		vc.makeScreenBlack()

		UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
			vc.view.alpha = 0
			self.anchoredConstraints?.top?.constant = startingPoint.origin.y
			self.anchoredConstraints?.leading?.constant = startingPoint.origin.x
			self.anchoredConstraints?.height?.constant = startingPoint.height
			self.anchoredConstraints?.width?.constant = startingPoint.width
			self.view.layoutIfNeeded()
			self.tabBarController?.tabBar.transform = .identity
			self.navigationController?.navigationBar.transform = .identity

		}, completion: { _ in
			vc.removeChildFromVC()
			DispatchQueue.main.async {
				self.prepareData()
			}
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

@nonobjc extension UIViewController {

	func addChildToVC(_ child: UIViewController) {
		addChild(child)
		view.addSubview(child.view)
		child.didMove(toParent: self)
	}

	func removeChildFromVC() {
		willMove(toParent: nil)
		view.removeFromSuperview()
		removeFromParent()
	}
}
