//
//  EditPlaceView.swift
//  Places
//
//  Created by Michael Schembri on 23/2/20.
//  Copyright © 2020 Michael Schembri. All rights reserved.
//

import SwiftUI

struct EditPlaceView: View {

	var place: Place
	@State private var newName: String = ""
	@State private var selectedColor: Int
    @Environment(\.presentationMode) var presentationMode
	@EnvironmentObject var appState: AppState
	@State private var hasLoaded = false
	var pickerData = [(key: MarkerColor, value: String)]()

	init(place: Place) {

		self.place = place

		pickerData = User.current.categories.map { (key: MarkerColor, value: String) in
			return (key, value)
		}

		pickerData.sort(by: { $0.value < $1.value })

		if let index = pickerData.firstIndex(where: { $0.key == place.category }) {
			_selectedColor = State(initialValue: index)
		} else {
			_selectedColor = State(initialValue: 0)
		}

		_newName = State(initialValue: place.name)
	}

    var body: some View {
		VStack {
			ZoomMapViewSwiftUI2(place: self.place)
				.frame(height: 300)

			Text(place.name)
				.padding()
				.font(.system(size: 22, weight: .black))
				.multilineTextAlignment(.center)

			Form {
				TextField("Place name", text: $newName)
					.font(.body)
					.padding()
					.modifier(ClearButton(text: $newName))

				Picker(selection: $selectedColor, label: Text("")) {
					ForEach(0 ..< pickerData.count) { i in
						Text(User.current.categories[self.pickerData[i].key] ?? "")
							.font(.body)
							.padding()
							.tag(i)
					}
				}
				.labelsHidden()

				Section {
					Button("Delete") {
						self.deletePlace()
						self.presentationMode.wrappedValue.dismiss()
					}
					.foregroundColor(.red)
					.font(.system(size: 22, weight: .bold))
					.padding()
					.disabled(self.newName.isEmpty)
				}
			}
		}
		.edgesIgnoringSafeArea(.top)
		.onDisappear {
			let selected = self.pickerData[self.selectedColor]
			self.updatePlace(self.place, name: self.newName, category: selected.key)
		}
    }

	func updatePlace(_ place: Place, name: String, category: MarkerColor) {
		if (name == place.name && category == place.category) || name.isEmpty {
			return
		}

		User.current.updatePlace(place: place, name: name, category: category)

		appState.places = User.current.places
	}

	func deletePlace() {
		User.current.markAsDeletedPlace(self.place)
		appState.places = User.current.places
	}
}

struct EditPlaceView_Previews: PreviewProvider {

	static let place: Place = Place(name: "1", address: "ww", lat: -33.852222, long: 151.21, id: "22", category: .red, isDeleted: false)

    static var previews: some View {
        EditPlaceView(place: place)
    }
}
