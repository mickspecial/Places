//
//  MapScreenView.swift
//  Places
//
//  Created by Michael Schembri on 22/2/20.
//  Copyright © 2020 Michael Schembri. All rights reserved.
//

import SwiftUI

struct MapScreenView: View {

	@EnvironmentObject var appState: AppState

	@State var selectedPin: Place?

	@State var startPin: Place?
	@State var endPin: Place?

    var body: some View {

		ZStack(alignment: .bottom) {
			VStack {
				MapViewSwiftUI(places: self.$appState.places, highlighted: self.$appState.highlighted, selectedPin: self.$selectedPin, startPin: self.$startPin, endPin: self.$endPin)

				if selectedPin != nil || startPin != nil || endPin != nil {
					HStack {
						Spacer()

						Image(systemName: "flag.circle")
							.font(Font.system(size: 80, weight: .light))
							.foregroundColor(self.startPin == nil ? Color(UIColor.gray) : Color(UIColor.systemGreen))
							.onTapGesture { self.toggleStartPin() }

						Spacer()

						Image(systemName: "flag.circle")
							.font(Font.system(size: 80, weight: .light))
							.foregroundColor(self.endPin == nil ? Color(UIColor.gray) : Color(UIColor.systemRed))
							.onTapGesture { self.toggleEndPin() }

						Spacer()
					}
					.padding()
					.padding(.bottom, 10)
					.animation(Animation.default.speed(2))
				}
		}
		}
	}

	func toggleStartPin() {
		print("START")
		if self.startPin == self.selectedPin {
			// already seleted so remove
			self.startPin = nil
		} else {
			self.startPin = self.selectedPin
		}
	}

	func toggleEndPin() {
		print("END")
		if self.endPin == self.selectedPin {
			// already seleted so remove
			self.endPin = nil
		} else {
			self.endPin = self.selectedPin
		}
	}
}

//struct MapScreenView_Previews: PreviewProvider {
//
//    static var previews: some View {
//		MapScreenView().environmentObject(AppState(user: User()))
//    }
//}
