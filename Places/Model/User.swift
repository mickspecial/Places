//
//  User.swift
//  Places
//
//  Created by Michael Schembri on 15/4/19.
//  Copyright © 2019 Michael Schembri. All rights reserved.
//

import Foundation

final class User: Codable {
	private (set) var places = [Place]()
	private (set) var categories = [MarkerColor: String]()

	private func saveUser() {
		DispatchQueue.main.async {
			self.save()
		}
	}

	func addPlace(_ place: Place) {
		places.append(place)
		saveUser()
	}

	func updateCategories(new: [MarkerColor: String]) {
		self.categories = new
		saveUser()
	}

	func updateCategory(colour: MarkerColor, value: String) {
		categories[colour] = value
		saveUser()
	}

	func updatePlace(place: Place, name: String, category: MarkerColor) {
		let newPlace = Place(name: name, address: place.address, lat: place.lat, long: place.long, id: place.id, category: category, isDeleted: place.isDeleted)
		places.removeAll(where: { place.id == $0.id })
		User.current.addPlace(newPlace)
		saveUser()
	}

	func markAsDeletedPlace(_ place: Place) {
		let newPlace = Place(name: place.name, address: place.address, lat: place.lat, long: place.long, id: place.id, category: place.category, isDeleted: true)
		places.removeAll(where: { place.id == $0.id })
		User.current.addPlace(newPlace)
		saveUser()
	}
}

extension User {
	/// The UserDefaults key where the real user is stored.
	fileprivate static var liveKeyName: String { return "User" }

	/// The UserDefaults key where the test user is stored so we don't break the live user when running tests.
	fileprivate static var testKeyName: String { return "TestUser" }

	/// Loads a user from UserDefaults, or returns nil if there was none.
	static func load(testMode: Bool = false) -> User? {
		let keyName: String

		if testMode == true {
			keyName = testKeyName
		} else {
			keyName = liveKeyName
		}

		let defaults = UserDefaults.standard
		if let data = defaults.data(forKey: keyName) {
			let decoder = JSONDecoder()
			decoder.dateDecodingStrategy = .iso8601

			if let decodedUser = try? decoder.decode(User.self, from: data) {
				print("Load User Success")
				return decodedUser
			}
		}

		print("Nothing To Load")
		return nil
	}

	/// Saves a user to user defaults.
	func save(testMode: Bool = false) {

		print("try save")

		let keyName: String

		if testMode == true {
			keyName = User.testKeyName
		} else {
			keyName = User.liveKeyName
		}

		let defaults = UserDefaults.standard
		let encoder = JSONEncoder()
		encoder.dateEncodingStrategy = .iso8601

		if let encodedUser = try? encoder.encode(self) {

			print("SAVING 2")
//			print(places)
			print(categories)

			defaults.set(encodedUser, forKey: keyName)
		} else {
			print("Failed to save user.")
		}
	}

	/// Destroys any existing user so we can be sure we have a blank slate when testing.
	static func destroyTestUser() {
		let defaults = UserDefaults.standard
		defaults.removeObject(forKey: testKeyName)
		defaults.removeObject(forKey: liveKeyName)
	}
}

extension User {
	static var current: User!
	/// Future release
	/// static let maxPlaceForFree = 20
}
