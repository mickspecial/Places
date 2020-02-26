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
			MapViewSwiftUI(places: self.$appState.places, highlighted: self.$appState.highlighted, selectedPin: self.$selectedPin, startPin: self.$startPin, endPin: self.$endPin)

			//toggleButtons
			DestinationButtons(startPin: $startPin, endPin: $endPin, selectedPin: $selectedPin)
		}
	}
}
