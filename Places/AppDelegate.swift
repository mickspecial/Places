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
}
