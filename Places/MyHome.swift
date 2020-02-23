//
//  MyHome.swift
//  Places
//
//  Created by Michael Schembri on 21/2/20.
//  Copyright © 2020 Michael Schembri. All rights reserved.

import SwiftUI
import MapKit

struct MyHome: View {

	@EnvironmentObject var appState: AppState

	@State private var selected: Int = 0

	//@State private var lm: [Place] = User.current.places
		//Place(name: "1", address: "ww", lat: -33.852222, long: 151.21, id: "22", category: .red, isDeleted: false)
		//Landmark(id: "1", name: "2", location: CLLocationCoordinate2D(latitude: -33.84, longitude: 151.21))

    var body: some View {
		VStack {
			if selected == 0 {
				PlacesListView().environmentObject(appState)
			}

			if selected == 1 {
				MapScreenView()
					.environmentObject(appState)
					.edgesIgnoringSafeArea(.top)
			}

//			if selected == 2 {
//				PlaceSearchView()
//			}

			Spacer()

			BottomTab(selected: $selected)
		}.onAppear {
			//self.lm = User.current.places
		}
    }
}

struct MyHome_Previews: PreviewProvider {
    static var previews: some View {
        MyHome()
    }
}
