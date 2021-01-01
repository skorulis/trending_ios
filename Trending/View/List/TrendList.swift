//
//  TrendList.swift
//  Trending
//
//  Created by Alexander Skorulis on 5/12/20.
//

import Foundation
import SwiftUI
import Combine
import Swinject

private class TrendListViewModel: ObservableObject {
    
    @Published var twitterTrends = [TrendItem]()
    @Published var googleTrends = [TrendItem]()
    @Published var timeIndex: Int = 0 {
        didSet {
            print("SEt value")
            getTrends()
        }
    }
    var isLoading: Bool = false
    
    var seconds: TimeInterval {
        switch timeIndex {
        case 0:
            return 24 * 60 * 60
        case 1:
            return 12 * 60 * 60
        case 2:
            return 60 * 60
        default:
            return 24 * 60 * 60
        }
    }
    
    private var subscribers = Set<AnyCancellable>()
    let client: TrendingClient
    let place: Place?
    
    init(place: Place?, client: TrendingClient) {
        self.place = place
        self.client = client
        getTrends()
    }
    
    func getTrends() {
        subscribers.removeAll() //Cancel any outstanding
        isLoading = true
        client.getTop(seconds: seconds, placeId: place?.id).sink { [weak self] (error) in
            //print("Handle error \(error)")
            self?.isLoading = false
        } receiveValue: { (trends) in
            self.twitterTrends = trends.twitter
            self.googleTrends = trends.google
        }.store(in: &subscribers)
        
    }
    
}

struct TrendList: View {
    
    @ObservedObject private var viewModel: TrendListViewModel
    #if DEBUG
    @ObservedObject var iO = injectionObserver
    #endif
    
    private let locator: Servicelocator
    private let place: Place?
    
    init(place: Place? = nil,  locator: Servicelocator) {
        self.locator = locator
        self.place = place
        viewModel = TrendListViewModel(place: place, client: locator.resolve()!)
    }
    
    private var header: some View {
        Picker(selection: $viewModel.timeIndex, label: Text("Picker")) {
            Text("24hr").tag(0)
            Text("12hr").tag(1)
            Text("1hr").tag(2)
        }.pickerStyle(SegmentedPickerStyle())
        
    }
    
    var body: some View {
        var title = "Trends"
        if let place = self.place {
            title = "\(place.name)"
        }
        
        return List {
            Section(header: header) { }
                        
            if viewModel.isLoading {
                LoadingIndicator()
            } else {
                Section(header: Text("Twitter")) {
                    ForEach(viewModel.twitterTrends, id: \.self) { trend in
                        return NavigationLink(destination: NavigationLazyView(TrendDetail(trend: trend, seconds: viewModel.seconds, locator: locator))) {
                            TrendRow(model: trend)
                        }
                    }
                }
                Section(header: Text("Google")) {
                    ForEach(viewModel.googleTrends, id: \.self) { trend in
                        return NavigationLink(destination: NavigationLazyView(TrendDetail(trend: trend, seconds: viewModel.seconds, locator: locator))) {
                            TrendRow(model: trend)
                        }
                    }
                }
            }
        }
        .navigationBarTitle(title)
    }
}


struct TrendList_Previews: PreviewProvider {
    static var previews: some View {
        TrendList(locator: Servicelocator())
    }
}
