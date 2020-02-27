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
				Section(header: Image("red")) {
					TextField("Red", text: $red)
				}.listRowInsets(EdgeInsets.appDefault())

				Section(header: Image("green")) {
					TextField("Green", text: $green)
				}.listRowInsets(EdgeInsets.appDefault())

				Section(header: Image("blue")) {
					TextField("Blue", text: $blue)
				}.listRowInsets(EdgeInsets.appDefault())

				Section(header: Image("white")) {
					TextField("White", text: $white)
				}.listRowInsets(EdgeInsets.appDefault())

				Section(header: Image("cyan")) {
					TextField("Cyan", text: $cyan)
				}.listRowInsets(EdgeInsets.appDefault())

				Section(header: Image("orange")) {
					TextField("Orange", text: $orange)
				}.listRowInsets(EdgeInsets.appDefault())

				Section(header: Image("purple")) {
					TextField("Purple", text: $purple)
				}.listRowInsets(EdgeInsets.appDefault())

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

	func saveTags() {
		checkShouldSave(marker: .red, newValue: red)
		checkShouldSave(marker: .green, newValue: green)
		checkShouldSave(marker: .blue, newValue: blue)
		checkShouldSave(marker: .white, newValue: white)
		checkShouldSave(marker: .cyan, newValue: cyan)
		checkShouldSave(marker: .orange, newValue: orange)
		checkShouldSave(marker: .purple, newValue: purple)
	}

	func checkShouldSave(marker: MarkerColor, newValue: String) {
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
