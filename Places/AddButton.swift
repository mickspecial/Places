//
//  AddButton.swift
//  Places
//
//  Created by Michael Schembri on 21/2/20.
//  Copyright © 2020 Michael Schembri. All rights reserved.
//

import SwiftUI

struct AddButton: View {

	var size: CGFloat = 60
	@Binding var isShowing: Bool

	var body: some View {
		Button(action: {
			withAnimation {
				self.isShowing.toggle()
			}
		}) {
			Image(systemName: "plus.circle.fill")
				.resizable()
				.frame(width: size, height: size)
				.foregroundColor(Color.green)
				.background(Color.white)
				.clipShape(Circle())
		}
	}
}

struct AddButton_Previews: PreviewProvider {
    static var previews: some View {
		AddButton(isShowing: .constant(true))
			.previewLayout(.sizeThatFits)
    }
}

struct DestinationButtons: View {

	var size: CGFloat = 80
	@Binding var startPin: Place?
	@Binding var endPin: Place?
	@Binding var selectedPin: Place?

	var currentState: DBState {
		DBState(startPin: startPin, endPin: endPin, selectedPin: selectedPin)
	}

	enum DBState {
		case anySelected
		case noneSelected

		init(startPin: Place?, endPin: Place?, selectedPin: Place?) {
			if startPin != nil || endPin != nil || selectedPin != nil {
				self = .anySelected
			} else {
				self = .noneSelected
			}
		}
	}

	var body: some View {
		toggleButtons
			.opacity(currentState == .anySelected ? 1 : 0)
	}

	var toggleButtons: some View {
		HStack {
			Spacer()

			Image(systemName: "flag.circle.fill")
				.font(Font.system(size: size, weight: .light))
				.foregroundColor(self.startPin == nil ? Color(UIColor.gray) : Color(UIColor.systemGreen))
				.onTapGesture { self.toggleStartPin() }

			Spacer()

			Image(systemName: "flag.circle.fill")
				.font(Font.system(size: size, weight: .light))
				.foregroundColor(self.endPin == nil ? Color(UIColor.gray) : Color(UIColor.systemRed))
				.onTapGesture { self.toggleEndPin() }

			Spacer()
		}
		.padding()
		.padding(.bottom, 10)
		.animation(Animation.default.speed(2))
	}

	func toggleStartPin2() {

		if let selected = selectedPin {
			print("set start pin to selected pin")
			startPin = selected
			assert(startPin != nil)

			if let end = endPin, end == startPin {
				print("end pin same as start to clear the end pin")
				assert(endPin != nil)
				assert(endPin == startPin)
				endPin = nil
				assert(endPin == nil)
				assert(startPin != nil)
			}
		} else {
			print("clear start pin as nothing selected")
			startPin = nil
			assert(startPin == nil)
		}
	}

	func toggleStartPin() {
		if let selected = selectedPin {
			print("set start pin to selected pin")
			startPin = selected
			assert(startPin != nil)

			if let end = endPin, end == startPin {
				print("end pin same as start to clear the end pin")
				assert(endPin != nil)
				assert(endPin == startPin)
				endPin = nil
				assert(endPin == nil)
				assert(startPin != nil)
			}
		} else {
			print("clear start pin as nothing selected")
			startPin = nil
			assert(startPin == nil)
		}
	}

	func toggleEndPin() {
		if let selected = selectedPin {
			print("set end pin to selected pin")
			endPin = selected
			assert(endPin != nil)

			if let start = startPin, start == endPin {
				print("start pin same as end to clear the start pin")
				assert(startPin != nil)
				assert(endPin == startPin)
				startPin = nil
				assert(startPin == nil)
				assert(endPin != nil)
			}
		} else {
			print("clear end pin as nothing selected")
			endPin = nil
			assert(endPin == nil)
		}
	}
}
