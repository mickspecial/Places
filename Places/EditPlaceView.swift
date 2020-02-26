//
//  EditPlaceView.swift
//  Places
//
//  Created by Michael Schembri on 23/2/20.
//  Copyright © 2020 Michael Schembri. All rights reserved.
//

import SwiftUI

struct EditPlaceView: View {

	@State var place: Place
	@State var marker: MarkerColor
	@State private var newName: String = ""
	@State private var selectedColor: Int
    @Environment(\.presentationMode) var presentationMode
	@EnvironmentObject var appState: AppState
	@State private var hasLoaded = false
	@State private var userColorsMarkers: [UserMarker]

	init(place: Place) {
		let cats = User.current.categories
		_place = State(initialValue: place)
		_marker = State(initialValue: place.category)
		_userColorsMarkers = State(initialValue: MarkerColor.sortedUserMarkers(userData: cats))
		_newName = State(initialValue: place.name)
		_selectedColor = State(initialValue: MarkerColor.indexForMarker(userData: cats, markerColor: place.category))
	}

    var body: some View {
		VStack {
			DetailsViewMapViewSwiftUI(place: self.$place, marker: self.$marker)
				.frame(height: 300)

			Text(place.name)
				.padding()
				.font(.system(size: 22, weight: .black))
				.multilineTextAlignment(.center)

			Form {
				Section {
					TextField("Place name", text: $newName)
						.font(.body)
						.padding()
						.modifier(ClearButton(text: $newName))

					Picker(selection: $selectedColor, label: Text("")) {
						ForEach(0 ..< userColorsMarkers.count, id: \.self) { i in
							Text(self.userColorsMarkers[i].customText)
								.font(.body)
								.padding()
								.tag(i)
						}
						.listRowInsets(EdgeInsets.appDefault())
					}
					.labelsHidden()
				}

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
			.navigationViewStyle(StackNavigationViewStyle())

		}
		.navigationViewStyle(StackNavigationViewStyle())
		.navigationBarTitle("", displayMode: .inline)
		.edgesIgnoringSafeArea(.top)
		.onDisappear {
			#warning("fix")
			print("Gone...when go to picker this is fired")
			self.updatePlace(self.place, name: self.newName, category: self.userColorsMarkers[self.selectedColor].color)
		}
		.onAppear {
			// update the map
			self.marker = self.userColorsMarkers[self.selectedColor].color
		}
    }

	func updatePlace(_ place: Place, name: String, category: MarkerColor) {
		if (name == place.name && category == place.category) || name.isEmpty {
			return
		}

		User.current.updatePlace(place: place, name: name, category: category)
		appState.places = User.current.places.filter({ $0.isDeleted == false })
	}

	func deletePlace() {
		User.current.markAsDeletedPlace(place)
		appState.places = User.current.places.filter({ $0.isDeleted == false })
	}
}

struct EditPlaceView_Previews: PreviewProvider {

	static let place: Place = Place(name: "1", address: "ww", lat: -33.852222, long: 151.21, id: "22", category: .red, isDeleted: false)

    static var previews: some View {
        EditPlaceView(place: place)
    }
}

extension EdgeInsets {
	static func appDefault() -> EdgeInsets {
		return .init(top: 0, leading: 16, bottom: 0, trailing: 16)
	}
}
