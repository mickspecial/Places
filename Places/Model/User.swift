//
//  User.swift
//  Places
//
//  Created by Michael Schembri on 15/4/19.
//  Copyright © 2019 Michael Schembri. All rights reserved.
//

import Foundation

class AppState: ObservableObject {

	@Published var places: [Place]
	@Published var highlighted: Place?
	@Published var selected: Int

	init(user: User) {
		self.selected = 0
		self.places = user.places.filter({ $0.isDeleted == false })
		//self.highlighted = user.places.filter({ $0.isDeleted == false }).first!

//		DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
//			self.highlighted = user.places.filter({ $0.isDeleted == false }).first!
//		}
	}
}

final class User: Codable {
	// created with an empty slate
	private (set) var places = [Place]()
	private (set) var categories = [MarkerColor: String]()
	private (set) var created = Date()
	private (set) var modified = Date()
	private (set) var id = UUID().uuidString

	private func saveUser() {
		DispatchQueue.main.async {
			self.modified = Date()
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

	/// Loads a user from UserDefaults, or returns nil if there was none.
	static func load(testMode: Bool = false) -> User? {

		let decoder = JSONDecoder()
		decoder.dateDecodingStrategy = .iso8601

		let defaults = UserDefaults.standard

		if let data = defaults.data(forKey: liveKeyName) {
			if let decodedUser = try? decoder.decode(User.self, from: data) {
				print("Load Local User Success")
				return decodedUser
			}
		}

		return nil
	}

	/// Saves a user to user defaults
	func save(testMode: Bool = false) {

		let encoder = JSONEncoder()
		encoder.dateEncodingStrategy = .iso8601

		if let encodedUser = try? encoder.encode(self) {
			let defaults = UserDefaults.standard
			defaults.set(encodedUser, forKey: User.liveKeyName)
		}
	}

	/// Destroys any existing user so we can be sure we have a blank slate when testing.
	static func destroyTestUser() {
		print(" ⛔️ DB CLEAR ⛔️ ")
		let defaults = UserDefaults.standard
		defaults.removeObject(forKey: liveKeyName)
	}
}

extension User {
	static var current: User!
}
