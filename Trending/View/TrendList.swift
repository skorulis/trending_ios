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
    private let locator: Servicelocator
    
    init(locator: Servicelocator) {
        self.locator = locator
        topTrends = locator.resolve()!
    }
    
    var trendData: [TrendItem] = [
        TrendItem(id: UUID(), key: "row 1", display: "row 1", value: 1),
        TrendItem(id: UUID(), key: "row 1", display: "row 2", value: 1)
    ]
    
    var body: some View {
        List(topTrends.trends) { trend  in
            NavigationLink(destination: NavigationLazyView(TrendDetail(trend: trend, locator: locator))) {
                TrendRow(model: trend)
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
