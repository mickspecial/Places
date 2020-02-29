//
//  PlacesListView.swift
//  Places
//
//  Created by Michael Schembri on 21/2/20.
//  Copyright © 2020 Michael Schembri. All rights reserved.
//

import SwiftUI

struct PlacesListView: View {

	@State private var isShowing = false
	@EnvironmentObject var appState: AppState

    var body: some View {
		NavigationView {

			ZStack(alignment: .bottomTrailing) {

				VStack {
					List {
						ForEach(appState.places.sorted(by: { $0.name < $1.name }), id: \.id) { place in

						NavigationLink(destination: EditPlaceView(place: place)) {
							Image(uiImage: place.markerImage)
								.resizable()
								.frame(width: 30, height: 30)
								.scaledToFit()
								.padding(.trailing, 4)
								.onTapGesture {
									//withAnimation {
									// clear all filtered / hiden markers 
										self.appState.hideMarkers.removeAll()
										self.appState.highlighted = place
										self.appState.selected = 1
									//}
								}
							VStack(alignment: .leading) {
								Text(place.name)
									.font(.headline)
								Text(place.address)
									.font(.subheadline)
							}.padding(.vertical)
						}
						}
					}
				}

				AddButton(isShowing: self.$isShowing)
					.padding()
			}
			.sheet(isPresented: $isShowing) {
				PlaceSearchView().environmentObject(self.appState)
			}

			.navigationBarTitle("Places")
			.onAppear {
				self.appState.highlighted = nil
			}
		}
		.navigationViewStyle(StackNavigationViewStyle())

	}
}

struct PlacesListView_Previews: PreviewProvider {
    static var previews: some View {
        PlacesListView()
    }
}
