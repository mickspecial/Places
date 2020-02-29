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
				ToggleRow(text: $red, marker: .red, title: "Red") {
					self.toggleMarker(marker: .red)
				}

				ToggleRow(text: $green, marker: .green, title: "Green") {
					self.toggleMarker(marker: .green)
				}

				ToggleRow(text: $blue, marker: .blue, title: "Blue") {
					self.toggleMarker(marker: .blue)
				}

				ToggleRow(text: $white, marker: .white, title: "White") {
					self.toggleMarker(marker: .white)
				}

				ToggleRow(text: $cyan, marker: .cyan, title: "Cyan") {
					self.toggleMarker(marker: .cyan)
				}

				ToggleRow(text: $orange, marker: .orange, title: "Orange") {
					self.toggleMarker(marker: .orange)
				}

				ToggleRow(text: $purple, marker: .purple, title: "Purple") {
					self.toggleMarker(marker: .purple)
				}

				if keyboard.currentHeight != 0 {
					Spacer(minLength: 300)
				}

			}
			.navigationBarTitle("Tags")
		}
		.navigationViewStyle(StackNavigationViewStyle())
		.onDisappear {
			self.saveTags()
		}
    }

	func toggleMarker(marker: MarkerColor) {
		if appState.hideMarkers.contains(marker) {
			appState.hideMarkers.remove(marker)
		} else {
			appState.hideMarkers.insert(marker)
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
	@EnvironmentObject var appState: AppState

	@Binding var text: String
	var marker: MarkerColor
	var title: String
	var image: String
	var action: (() -> Void)? = nil

	init(text: Binding<String>, marker: MarkerColor, title: String, image: String = "", action: (() -> Void)?) {
		_text = text
		self.marker = marker
		self.title = title
		self.image = image.isEmpty ? title.lowercased() : image
		self.action = action
	}

	var body: some View {
		Section(header:
			HStack {
				Image(image)
				Spacer()
				Button(action: {
					self.action?()
				}) {
					Image(systemName: isHiddenMarker ? "eye.slash.fill" : "eye")
						.foregroundColor(isHiddenMarker ? .systemGray : .systemBlue)
						.font(.system(size: 20, weight: .light))
				}
			}.padding(.vertical, 4)
		) {
			TextField(title, text: $text)
		}.listRowInsets(EdgeInsets.appDefault())
	}

	var isHiddenMarker: Bool {
		self.appState.hideMarkers.contains(marker)
	}
}
