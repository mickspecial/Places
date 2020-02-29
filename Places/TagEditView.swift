//
//  TagEditView.swift
//  Places
//
//  Created by Michael Schembri on 27/2/20.
//  Copyright © 2020 Michael Schembri. All rights reserved.
//

import SwiftUI

struct TagEditView: View {

	@EnvironmentObject var appState: AppState
	@State var red: String = ""
	@State var green: String = ""
	@State var blue: String = ""
	@State var white: String = ""
	@State var cyan: String = ""
	@State var orange: String = ""
	@State var purple: String = ""
	@ObservedObject private var keyboard = KeyboardResponder()

	@State var redMarkerIsOn: Bool = false
	@State var greenMarkerIsOn: Bool = false
	@State var blueMarkerIsOn: Bool = false
	@State var whiteMarkerIsOn: Bool = false
	@State var cyanMarkerIsOn: Bool = false
	@State var orangeMarkerIsOn: Bool = false
	@State var purpleMarkerIsOn: Bool = false

	init() {
		let cats = User.current.categories
		_red = State(initialValue: cats[.red] ?? "")
		_green = State(initialValue: cats[.green] ?? "")
		_blue = State(initialValue: cats[.blue] ?? "")
		_white = State(initialValue: cats[.white] ?? "")
		_cyan = State(initialValue: cats[.cyan] ?? "")
		_orange = State(initialValue: cats[.orange] ?? "")
		_purple = State(initialValue: cats[.purple] ?? "")
	}

    var body: some View {
		NavigationView {
			Form {

				ToggleRow(markerIsOn: $redMarkerIsOn, text: $red, marker: .red, title: "Red", image: "red") {
					self.toggleMarker(marker: .red)
				}

				ToggleRow(markerIsOn: $greenMarkerIsOn, text: $green, marker: .green, title: "Green", image: "green") {
					self.toggleMarker(marker: .green)
				}

				ToggleRow(markerIsOn: $blueMarkerIsOn, text: $blue, marker: .blue, title: "Blue", image: "blue") {
					self.toggleMarker(marker: .blue)
				}

				ToggleRow(markerIsOn: $whiteMarkerIsOn, text: $white, marker: .white, title: "White", image: "white") {
					self.toggleMarker(marker: .white)
				}

				ToggleRow(markerIsOn: $cyanMarkerIsOn, text: $cyan, marker: .cyan, title: "Cyan", image: "cyan") {
					self.toggleMarker(marker: .cyan)
				}

				ToggleRow(markerIsOn: $orangeMarkerIsOn, text: $orange, marker: .orange, title: "Orange", image: "orange") {
					self.toggleMarker(marker: .orange)
				}

				ToggleRow(markerIsOn: $purpleMarkerIsOn, text: $purple, marker: .purple, title: "Purple", image: "purple") {
					self.toggleMarker(marker: .purple)
				}

				if keyboard.currentHeight != 0 {
					Spacer(minLength: 300)
				}

			}
			.navigationBarTitle("Tags")
		}
		.onAppear {
			self.setpUp()
		}
		.navigationViewStyle(StackNavigationViewStyle())
		.onDisappear {
			self.saveTags()
		}
    }

	func setpUp() {
		self.redMarkerIsOn = !self.appState.hideMarkers.contains(.red)
		self.greenMarkerIsOn = !self.appState.hideMarkers.contains(.green)
		self.blueMarkerIsOn = !self.appState.hideMarkers.contains(.blue)
		self.whiteMarkerIsOn = !self.appState.hideMarkers.contains(.white)
		self.cyanMarkerIsOn = !self.appState.hideMarkers.contains(.cyan)
		self.orangeMarkerIsOn = !self.appState.hideMarkers.contains(.orange)
		self.purpleMarkerIsOn = !self.appState.hideMarkers.contains(.purple)
	}

	func toggleMarker(marker: MarkerColor) {
		if marker == .red {
			if redMarkerIsOn {
				appState.hideMarkers.insert(marker)
			} else {
				appState.hideMarkers.remove(marker)
			}
		} else if marker == .green {
			if greenMarkerIsOn {
				appState.hideMarkers.insert(marker)
			} else {
				appState.hideMarkers.remove(marker)
			}
		} else if marker == .blue {
			if blueMarkerIsOn {
				appState.hideMarkers.insert(marker)
			} else {
				appState.hideMarkers.remove(marker)
			}
		} else if marker == .white {
			if whiteMarkerIsOn {
				appState.hideMarkers.insert(marker)
			} else {
				appState.hideMarkers.remove(marker)
			}
		} else if marker == .cyan {
			if cyanMarkerIsOn {
				appState.hideMarkers.insert(marker)
			} else {
				appState.hideMarkers.remove(marker)
			}
		} else if marker == .orange {
			if orangeMarkerIsOn {
				appState.hideMarkers.insert(marker)
			} else {
				appState.hideMarkers.remove(marker)
			}
		} else if marker == .purple {
			if purpleMarkerIsOn {
				appState.hideMarkers.insert(marker)
			} else {
				appState.hideMarkers.remove(marker)
			}
		}
	}

	func saveTags() {
		update(marker: .red, to: red)
		update(marker: .green, to: green)
		update(marker: .blue, to: blue)
		update(marker: .white, to: white)
		update(marker: .cyan, to: cyan)
		update(marker: .orange, to: orange)
		update(marker: .purple, to: purple)
	}

	func update(marker: MarkerColor, to newValue: String) {
		if !newValue.isEmptyOrWhitespace() && newValue != User.current.categories[marker] {
			User.current.updateCategory(colour: marker, value: newValue)
		}
	}
}

struct TagEditView_Previews: PreviewProvider {
    static var previews: some View {
        TagEditView()
    }
}

extension String {
    func isEmptyOrWhitespace() -> Bool {

        // Check empty string
        if self.isEmpty {
            return true
        }
        // Trim and check empty string
        return (self.trimmingCharacters(in: .whitespaces) == "")
    }
}

struct ToggleRow: View {

	@Binding var markerIsOn: Bool
	@Binding var text: String
	var marker: MarkerColor
	var title: String
	var image: String
	var action: (() -> Void)? = nil

	var body: some View {
		Section(header:
			HStack {
				Image(image)
				Spacer()
				Toggle(isOn: $markerIsOn) {
					Text("")
				}.onTapGesture {
					self.action?()
				}
			}.padding(.vertical, 4)
		) {
			TextField(title, text: $text)
		}.listRowInsets(EdgeInsets.appDefault())
	}
}
