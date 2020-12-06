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

struct TrendList: View {
    
    @ObservedObject private var topTrends:TopTrendsObservable
    @State private var timeIndex = 0
    private let locator: Servicelocator
    
    init(locator: Servicelocator) {
        self.locator = locator
        topTrends = locator.resolve()!
    }
    
    private var header: some View {
        Picker(selection: $timeIndex, label: Text("Picker")) {
            Text("24hr").tag(0)
            Text("12hr").tag(1)
            Text("1hr").tag(2)
        }.pickerStyle(SegmentedPickerStyle())
    }
    
    var body: some View {
        List {
            Section(header: header) {
                ForEach(topTrends.trends, id: \.self) { trend in
                    return NavigationLink(destination: NavigationLazyView(TrendDetail(trend: trend, locator: locator))) {
                        TrendRow(model: trend)
                    }
                }
                
            }
        }
        .navigationBarTitle("Trends")
    }
}


struct TrendList_Previews: PreviewProvider {
    static var previews: some View {
        TrendList(locator: Servicelocator())
    }
}


final class TopTrendsObservable: ObservableObject, ServiceType {
    
    static func make(_ resolver: Resolver) -> TopTrendsObservable {
        return TopTrendsObservable(client: resolver.res()!)
    }
    
    @Published var trends = [TrendItem]()
    private var subscribers = Set<AnyCancellable>()
    
    let client: TrendingClient
    
    init(client: TrendingClient) {
        self.client = client
        client.getTop().sink { (error) in
            print("Handle error \(error)")
        } receiveValue: { (trends) in
            self.trends = trends
        }.store(in: &subscribers)

    }
    
}
