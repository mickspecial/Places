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
	@State var userPlacedPoints = Set<PolygonAnnotation>()
	@State var dropPinMode = false

    var body: some View {
		
		ZStack(alignment: .bottom) {
			MapViewSwiftUI(places: self.$appState.placesFiltered, highlighted: self.$appState.highlighted, selectedPin: self.$selectedPin, startPin: self.$startPin, endPin: self.$endPin, userPlacedPoints: self.$userPlacedPoints, dropPinMode: $dropPinMode)

			DestinationButtons(startPin: $startPin, endPin: $endPin, selectedPin: $selectedPin)

			AreaMarkerButtons(userPlacedPoints: $userPlacedPoints, dropPinMode: $dropPinMode)

			if dropPinMode && userPlacedPoints.count < 3 {
				VStack {
					Text("Area: add 3+ markers by tapping")
						.font(.system(size: 14, weight: .bold))
						.padding()
						.background(Capsule().fill(Color.systemBackground))
						.padding(.top, 50)
						.padding(.leading, 60)

					Spacer()
				}
			}

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
						.foregroundColor(.systemBlue)
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

struct AreaMarkerButtons: View {

	var size: CGFloat = 50
	@Binding var userPlacedPoints: Set<PolygonAnnotation>
	@Binding var dropPinMode: Bool

	var closedColor: Color {
		userPlacedPoints.isEmpty ? .systemGray : .systemOrange
	}

	var body: some View {
		HStack {
			VStack(spacing: 50) {
				dropPinModeButton
				if dropPinMode {
					clearPolygonButton
				}
				Spacer()
			}
			Spacer()
		}
		.padding(30)
		.padding(.top, 30)
	}

	private var clearPolygonButton: some View {
		Button(action: {
			self.userPlacedPoints.removeAll()
		}) {
			Image(systemName: "trash.circle.fill")
				.font(.system(size: 52, weight: .regular))
				.foregroundColor(.systemRed)
				.background(Circle().fill(Color.white))
		}
	}

	private var dropPinModeButton: some View {
		Image(systemName: "skew")
			.font(.system(size: 48, weight: .regular))
			.foregroundColor(dropPinMode ? .systemGreen : closedColor)
			.onTapGesture {
				self.dropPinMode.toggle()
			}
	}

}
