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
	@State private var willDelete = false
	@ObservedObject private var keyboard = KeyboardResponder()
	@State private var isActive = false

	init(place: Place) {
		let cats = User.current.categories
		_place = State(initialValue: place)
		_marker = State(initialValue: place.category)
		_userColorsMarkers = State(initialValue: MarkerColor.sortedUserMarkers(userData: cats))
		_newName = State(initialValue: place.name)
		_selectedColor = State(initialValue: MarkerColor.indexForMarker(userData: cats, markerColor: place.category))
	}

    var body: some View {
		VStack(spacing: 0) {

			DetailsViewMapViewSwiftUI(place: self.$place, marker: self.$marker)
				.frame(height: keyboard.currentHeight == 0 ? 300 : 100)
				.animation(.spring())

			Form {
				Section {
					TextField("Place name", text: $newName)
						.font(.body)
						.padding()
						.modifier(ClearButton(text: $newName))

					Picker(selection: $selectedColor, label: Text("")) {
						ForEach(0 ..< userColorsMarkers.count, id: \.self) { i in
							HStack {
								Image(uiImage: self.userColorsMarkers[i].color.markerImage)
									.renderingMode(.original)
									.resizable()
									.frame(width: 30, height: 30)
									.scaledToFit()
								Text(self.userColorsMarkers[i].customText)
									.font(.body)
									.padding()
									.tag(i)
							}
							.padding(.leading)
						}
						.listRowInsets(EdgeInsets.appDefault())
					}
					.labelsHidden()
				}
			}
			.animation(.spring())

		}
		.navigationViewStyle(StackNavigationViewStyle())
		.navigationBarTitle(Text(self.place.name), displayMode: .inline)
		.navigationBarItems(trailing:
			Button(action: {
				self.deletePlace()
				self.presentationMode.wrappedValue.dismiss()
			}) {
				Text("Delete").foregroundColor(.red)
		})
		.onDisappear {
			// #warning("fix")
			//print("Gone...when go to picker this is fired")
			if !self.willDelete {
				// print("qucik hack as to fix as changing color then delete wont actaully delete ")
				self.updatePlace(self.place, name: self.newName, category: self.userColorsMarkers[self.selectedColor].color)
			}
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
		self.willDelete = true
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

// rename cats

// edit name keyboard ... need to move up the screen

final class KeyboardResponder: ObservableObject {
    private var notificationCenter: NotificationCenter
    @Published private(set) var currentHeight: CGFloat = 0

    init(center: NotificationCenter = .default) {
        notificationCenter = center
        notificationCenter.addObserver(self, selector: #selector(keyBoardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyBoardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    deinit {
        notificationCenter.removeObserver(self)
    }

    @objc func keyBoardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            currentHeight = keyboardSize.height
        }
    }

    @objc func keyBoardWillHide(notification: Notification) {
        currentHeight = 0
    }
}

extension Animation {
    static func ripple(index: Int) -> Animation {
        Animation.spring(dampingFraction: 0.5)
            .speed(2)
            .delay(0.03 * Double(index))
    }
}

struct ResponderTextField: UIViewRepresentable {

    typealias TheUIView = UITextField
    var isFirstResponder: Bool
    var configuration = { (view: TheUIView) in }

    func makeUIView(context: UIViewRepresentableContext<Self>) -> TheUIView { TheUIView() }
    func updateUIView(_ uiView: TheUIView, context: UIViewRepresentableContext<Self>) {
        _ = isFirstResponder ? uiView.becomeFirstResponder() : uiView.resignFirstResponder()
        configuration(uiView)
    }
}
