//
//  SceneDelegate.swift
//  Places
//
//  Created by Michael Schembri on 26/6/19.
//  Copyright © 2019 Michael Schembri. All rights reserved.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

	var window: UIWindow?

	func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
		// Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
		// If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
		// This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).

		// Use a UIHostingController as window root view controller

//		tabBarController = MainTabBarController()
//		window = UIWindow(frame: UIScreen.main.bounds)
//		window?.backgroundColor = Theme.current.primary
//		window?.rootViewController = tabBarController
//		window?.tintColor = .darkGray
//		window?.makeKeyAndVisible()

		let state = AppState(user: User.current)

		let contentView = MyHome().environmentObject(state)

		if let windowScene = scene as? UIWindowScene {
			let window = UIWindow(windowScene: windowScene)
			window.rootViewController = UIHostingController(rootView: contentView)
			self.window = window
			window.makeKeyAndVisible()
		}

//		let window = UIWindow(frame: UIScreen.main.bounds)
//		window.rootViewController = UIHostingController(rootView: MyHome())
//		self.window = window
//		window.makeKeyAndVisible()
	}
}
