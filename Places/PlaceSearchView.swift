//
//  PlaceSearchView.swift
//  Places
//
//  Created by Michael Schembri on 22/2/20.
//  Copyright © 2020 Michael Schembri. All rights reserved.
//

import SwiftUI
import MapKit

struct PlaceSearchView: View {

	@State private var search: String = ""
	@State private var searchResults = [MKLocalSearchCompletion]()
	@State private var isShowing = false
	@State private var tappedPlace: MKLocalSearchCompletion? = nil
	@EnvironmentObject var appState: AppState

	var body: some View {

		NavigationView {

			VStack {
				SearchBar(text: $search, searchResults: $searchResults)

				List {
					ForEach(searchResults.filter({ !$0.title.isEmpty && !$0.title.isEmpty }), id: \.self) { place in
						Button(action: {
							self.tappedPlace = place
							self.isShowing.toggle()
						}) {
							VStack(alignment: .leading) {
								Label {
									$0.attributedText = self.fillCell(place)
								}

								Label {
									$0.attributedText = self.fillCell2(place)
								}
							}
						}
					}
				}.id(UUID())
			}
			.sheet(isPresented: $isShowing) {
				CreatePlaceView(place: self.tappedPlace!).environmentObject(self.appState)
			}
				
			.navigationBarTitle("Search")
		}
	}

	func fillCell(_ searchResult: MKLocalSearchCompletion) -> NSAttributedString {
		NSAttributedString.highlightedText(searchResult.title, ranges: searchResult.titleHighlightRanges, size: 17)
	}

	func fillCell2(_ searchResult: MKLocalSearchCompletion) -> NSAttributedString {
		NSAttributedString.highlightedText(searchResult.subtitle, ranges: searchResult.subtitleHighlightRanges, size: 14)
	}
}

struct PlaceSearchView_Previews: PreviewProvider {
    static var previews: some View {
        PlaceSearchView()
    }
}

struct SearchBar: UIViewRepresentable {

    @Binding var text: String
	@Binding var searchResults: [MKLocalSearchCompletion]

    final class Coordinator: NSObject, UISearchBarDelegate, MKLocalSearchCompleterDelegate {

        @Binding var text: String
		@Binding var searchResults: [MKLocalSearchCompletion]

		lazy private var searchCompleter: MKLocalSearchCompleter = {
			let searchCompleter = MKLocalSearchCompleter()
			searchCompleter.delegate = self
			return searchCompleter
		}()

		init(text: Binding<String>, searchResults: Binding<[MKLocalSearchCompletion]>) {
            _text = text
			_searchResults = searchResults
        }

        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

			text = searchText

			if let text = searchBar.text, text.isEmpty {
				searchCompleter.cancel()
				searchResults.removeAll()
			} else {
				searchCompleter.queryFragment = searchText
			}
        }

		func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
			searchResults = completer.results
		}

		func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
			searchCompleter.cancel()
			searchResults.removeAll()
			searchBar.text = ""
			text = ""
			searchBar.endEditing(true)
		}
    }

    func makeCoordinator() -> Coordinator {
		return Coordinator(text: $text, searchResults: $searchResults)
    }

    func makeUIView(context: UIViewRepresentableContext<SearchBar>) -> UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.delegate = context.coordinator
		searchBar.setShowsCancelButton(true, animated: true)
		searchBar.showsCancelButton = true
        return searchBar
    }

    func updateUIView(_ uiView: UISearchBar, context: UIViewRepresentableContext<SearchBar>) {
        uiView.text = text
    }
}

struct Label: UIViewRepresentable {

    typealias TheUIView = UILabel
    fileprivate var configuration = { (view: TheUIView) in }

    func makeUIView(context: UIViewRepresentableContext<Self>) -> TheUIView { TheUIView() }
    func updateUIView(_ uiView: TheUIView, context: UIViewRepresentableContext<Self>) {
        configuration(uiView)
    }
}
