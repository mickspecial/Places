//
//  MapScreenView.swift
//  Places
//
//  Created by Michael Schembri on 22/2/20.
//  Copyright © 2020 Michael Schembri. All rights reserved.
//

import SwiftUI
import MapKit

struct MapScreenView: View {

	@EnvironmentObject var appState: AppState
	@State var selectedPin: Place?
	@State var startPin: Place?
	@State var endPin: Place?

    var body: some View {
		ZStack(alignment: .bottom) {
			MapViewSwiftUI(places: self.$appState.placesFiltered, highlighted: self.$appState.highlighted, selectedPin: self.$selectedPin, startPin: self.$startPin, endPin: self.$endPin)

			DestinationButtons(startPin: $startPin, endPin: $endPin, selectedPin: $selectedPin)

			if endPin != nil {
				openWithMapsButton
			}
		}
	}

	private var openWithMapsButton: some View {
		VStack {
			HStack {
				Spacer()
				Button(action: {
					self.openWithAppleMaps(destination: self.endPin!)
				}) {
					Image(systemName: "arrowshape.turn.up.right.circle.fill")
						.font(.system(size: 42, weight: .regular))
						.foregroundColor(.blue)
				}
				.padding(20)
				.padding(.top, 30)

			}
			Spacer()
		}
	}

	func openWithAppleMaps(destination: Place) {
		let showMapItems = [destination.placeMapItem]
		MKMapItem.openMaps(with: showMapItems, launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
	}
}
