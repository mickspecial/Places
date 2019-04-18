//
//  AppDelegate.swift
//  Places
//
//  Created by Michael Schembri on 7/4/19.
//  Copyright © 2019 Michael Schembri. All rights reserved.
//

// swiftlint:disable line_length

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?
	var tabBarController: MainTabBarController?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//		User.destroyTestUser()
		User.current = User.load() ?? User()

		if User.current.categories.isEmpty {
			print("New User Created - Default Categories Added")

			User.current.updateCategories(new: [
				MarkerColor.blue: "Blue Marker",
				MarkerColor.red: "Red Marker",
				MarkerColor.orange: "Orange Marker",
				MarkerColor.cyan: "Cyan Marker",
				MarkerColor.white: "White Marker",
				MarkerColor.purple: "Purple Marker",
				MarkerColor.green: "Green Marker"
			])
		}

		print("Id: \(User.current.id) - mod: \(User.current.modified.simpleDate) - created: \(User.current.created.simpleDate) Load App: Categories = \(User.current.categories.count), Places = \(User.current.places.count)")

		// Theme
		UINavigationBar.appearance().tintColor = .white
		UINavigationBar.appearance().barTintColor = Theme.current.primaryDark
		let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
		UINavigationBar.appearance().titleTextAttributes = textAttributes
		UINavigationBar.appearance().largeTitleTextAttributes = textAttributes
		UINavigationBar.appearance().backgroundColor = Theme.current.primaryDark
		UINavigationBar.appearance().isOpaque = true

		UITextField.appearance().keyboardAppearance = .dark

		UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
		UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)

		UITabBar.appearance().backgroundColor = Theme.current.primaryDark
		UITabBar.appearance().tintColor = .white
		UITabBar.appearance().barTintColor = Theme.current.primaryDark

		tabBarController = MainTabBarController()
		window = UIWindow(frame: UIScreen.main.bounds)
		window?.rootViewController = tabBarController
		window?.tintColor = .darkGray
		window?.makeKeyAndVisible()
		return true
	}

	// MARK: - Handle File Sharing
	func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {

		guard url.pathExtension == "plcs" else { return false }

		if let tabController = window?.rootViewController as? UITabBarController {
			tabController.selectedIndex = 0
		}

		let alert = SCLAlertView(appearance: AlertService.standardNoCloseButtonV)

		alert.addButton("Replace Data") {
			Place.importData(from: url)

			if let tabController = self.window?.rootViewController as? UITabBarController {
				if let nav = tabController.selectedViewController {
					if let navcontroller = nav as? UINavigationController, let vc = navcontroller.viewControllers.first as? PlaceListController {
						vc.prepareData()
					}
				}
			}
		}

		alert.addButton("Cancel", backgroundColor: Theme.current.cellDark, textColor: .white, showTimeout: nil) { return }
		alert.showCustom("Import?", color: UIColor.FlatColor.Blue.Denim)

		return true
	}
}

extension Date {
	var simpleDate: String {
		let monthyearformatter = DateFormatter()
		monthyearformatter.dateFormat = "dd'/'MM'/'yy h:mm a"
		return monthyearformatter.string(from: self)
	}
}
