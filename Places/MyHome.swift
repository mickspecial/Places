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
	//@State var selected: Int

	//@State private var lm: [Place] = User.current.places
		//Place(name: "1", address: "ww", lat: -33.852222, long: 151.21, id: "22", category: .red, isDeleted: false)
		//Landmark(id: "1", name: "2", location: CLLocationCoordinate2D(latitude: -33.84, longitude: 151.21))

    var body: some View {
		VStack {
			if self.appState.selected == 0 {
				PlacesListView().environmentObject(appState)
			}

			if self.appState.selected == 1 {
				MapScreenView()
					.environmentObject(appState)
					.edgesIgnoringSafeArea(.top)
			}

			if self.appState.selected == 2 {
				TagEditView().environmentObject(appState)
			}

			Spacer()

			BottomTab(selected: self.$appState.selected)
		}.onAppear {
			//self.lm = User.current.places
		}
    }
}

//struct MyHome_Previews: PreviewProvider {
//    static var previews: some View {
//        MyHome()
//    }
//}
