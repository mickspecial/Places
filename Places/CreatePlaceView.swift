//
//  CreatePlaceView.swift
//  Places
//
//  Created by Michael Schembri on 22/2/20.
//  Copyright © 2020 Michael Schembri. All rights reserved.
//

import SwiftUI
import MapKit

struct CreatePlaceView: View {

	var place: MKLocalSearchCompletion

	@State private var maplocation: MKMapItem?
	@State private var newName: String = ""
	@State private var selectedColor = 0
    @Environment(\.presentationMode) var presentationMode
	@EnvironmentObject var appState: AppState
	@State var selectedPlace: [Place] = []
	@State private var userColorsMarkers: [UserMarker]

	init(place: MKLocalSearchCompletion) {
		self.place = place
		let cats = User.current.categories
		_userColorsMarkers = State(initialValue: MarkerColor.sortedUserMarkers(userData: cats))
	}

    var body: some View {
		NavigationView {

			VStack {

				if !selectedPlace.isEmpty {
					ZoomMapViewSwiftUI(place: self.$selectedPlace).frame(height: 300)
				}

				if selectedPlace.isEmpty {
					Rectangle()
						.fill(Color(UIColor.systemBackground))
						.frame(height: 300)
				}

				Text(place.title)
					.padding()
					.font(.system(size: 22, weight: .black))
					.multilineTextAlignment(.center)

				Form {
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
					}
					.labelsHidden()

					Section {
						Button("Save") {
							self.savePlace()
							self.presentationMode.wrappedValue.dismiss()
						}
						.font(.system(size: 22, weight: .bold))
						.padding()
						.disabled(self.newName.isEmpty)
					}
				}
			}
			.navigationBarHidden(true)
			.navigationBarTitle("")
		}
		.navigationViewStyle(StackNavigationViewStyle()) // fix picker offset bug
		.edgesIgnoringSafeArea(.top)
		.onAppear {
			self.completeTheSearch()
		}
    }

	func completeTheSearch() {

		let searchRequest = MKLocalSearch.Request(completion: self.place)
		let search = MKLocalSearch(request: searchRequest)

		search.start { (response, _) in
			guard let response = response, let item = response.mapItems.first else {
				//SCLAlertView(appearance: AlertService.standard).showError("Missing coordinate")
				return
			}

			self.maplocation = item
			self.selectedPlace = [Place(mapItem: item, name: "", category: .red)]
			self.newName = self.place.title
		}
	}

	func savePlace() {
		guard let mapItem = maplocation else {
			fatalError()
		}

		let newPlace = Place(mapItem: mapItem, name: newName, category: userColorsMarkers[selectedColor].color)
		User.current.addPlace(newPlace)

		//appState.places = User.current.places
		appState.places = User.current.places.filter({ $0.isDeleted == false })

	}
}

struct FilledButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
            .foregroundColor(configuration.isPressed ? .gray : .white)
            .padding()
            .background(Color.accentColor)
            .cornerRadius(8)
    }
}

struct ClearButton: ViewModifier {
	@Binding var text: String

	public func body(content: Content) -> some View {
		ZStack(alignment: .trailing) {
			content

			if !text.isEmpty {
				Button(action: { self.text = "" }
				) {
					Image(systemName: "delete.left")
						.foregroundColor(Color(UIColor.opaqueSeparator))
				}
			}
		}
	}
}
