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

    var body: some View {
		VStack {
			MapViewSwiftUI(places: self.$appState.places, highlighted: self.$appState.highlighted)

			if self.appState.highlighted == nil {
				Text("Missing").font(.largeTitle)
			} else {
				Text("\(self.appState.highlighted!.name)").font(.largeTitle)
			}
		}
	}
}

struct MapScreenView_Previews: PreviewProvider {

    static var previews: some View {
		MapScreenView().environmentObject(AppState(user: User()))
    }
}
