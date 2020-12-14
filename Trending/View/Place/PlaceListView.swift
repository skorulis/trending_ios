//
//  PlaceListView.swift
//  Trending
//
//  Created by Alexander Skorulis on 7/12/20.
//

import Foundation
import SwiftUI
import Combine

class PlaceListViewModel: ObservableObject {
    @Published var places: [Place] = []
    @Published var searchText: String = ""
    private var subscribers = Set<AnyCancellable>()
    
    let client: TrendingClient
    
    init(locator: Servicelocator) {
        client = locator.resolve()!
        client.getPlaces().sink { (completion) in
            if case let .failure(error) = completion {
                print("Failure getting routes \(error)")
            }
        } receiveValue: { (places) in
            self.places = places.sorted(by: { (p1, p2) -> Bool in
                return p1.name < p2.name
            })
        }.store(in: &subscribers)

    }
    
}

struct PlaceListView: View {
    
    @ObservedObject var viewModel: PlaceListViewModel
    private let locator: Servicelocator
    
    init(locator: Servicelocator) {
        self.locator = locator
        viewModel = PlaceListViewModel(locator: locator)
    }
    
    var visiblePlaces: [Place] {
        if viewModel.searchText.isEmpty {
            return viewModel.places
        }
        return viewModel.places.filter { $0.name.localizedStandardContains(viewModel.searchText)}
    }
    
    var body: some View {
        List {
            Section {
                SearchBar(text: $viewModel.searchText)
            }
            Section {
                ForEach(visiblePlaces) { place in
                    return NavigationLink(destination: NavigationLazyView(TrendList(place: place, locator: locator))) {
                        Text(place.name)
                    }
                }
            }
        }
        .modifier(ScreenViewAnalytics(pageName: "Places"))
        .navigationTitle("Places")
    }
}
