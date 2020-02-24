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
					List(appState.places.sorted(by: { $0.name < $1.name })) { place in
						NavigationLink(destination: EditPlaceView(place: place)) {
							Image(uiImage: place.markerImage)
								.resizable()
								.frame(width: 30, height: 30)
								.scaledToFit()
								.padding(.trailing, 4)
								.onTapGesture {
									print("TAP image")
									//withAnimation {
										self.appState.highlighted = place
										self.appState.selected = 1
									//}
								}
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
			.navigationViewStyle(StackNavigationViewStyle())
			.onAppear {
				print("remove any highlighted")
				self.appState.highlighted = nil
			}
		}
	}
}

struct PlacesListView_Previews: PreviewProvider {
    static var previews: some View {
        PlacesListView()
    }
}
