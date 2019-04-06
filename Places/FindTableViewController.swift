//
//  FindTableViewController.swift
//  Places
//
//  Created by Michael Schembri on 7/4/19.
//  Copyright © 2019 Michael Schembri. All rights reserved.
//

import UIKit

class FindTableViewController: UITableViewController {

	lazy private var searchController: UISearchController = {
		var sctrl = UISearchController()
		sctrl = UISearchController(searchResultsController: nil)
		sctrl.obscuresBackgroundDuringPresentation = false
		sctrl.searchBar.placeholder = "Find Place"
		sctrl.searchResultsUpdater = self
		navigationItem.searchController = sctrl
		navigationItem.hidesSearchBarWhenScrolling = false
		sctrl.searchBar.delegate = self
		definesPresentationContext = true
		return sctrl
	}()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		searchController.searchBar.becomeFirstResponder()
	}

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
}

extension FindTableViewController: UISearchResultsUpdating {

	func updateSearchResults(for searchController: UISearchController) {
		let text = searchController.searchBar.text ?? ""
		print(text)
	}
}

extension FindTableViewController: UISearchBarDelegate {

}
