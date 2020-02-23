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
					List(appState.places.sorted(by: { $0.name < $1.name }), id: \.self) { place in
						NavigationLink(destination: EditPlaceView(place: place)) {
							Text(place.name)
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
		}
	}
}

struct PlacesListView_Previews: PreviewProvider {
    static var previews: some View {
        PlacesListView()
    }
}
