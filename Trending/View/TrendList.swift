//
//  TrendList.swift
//  Trending
//
//  Created by Alexander Skorulis on 5/12/20.
//

import Foundation
import SwiftUI
import Combine

struct TrendList: View {
    
    @ObservedObject private var topTrends = TopTrendsObservable()
    
    var trendData: [TrendItem] = [
        TrendItem(id: UUID(), key: "row 1", display: "row 1", value: 1),
        TrendItem(id: UUID(), key: "row 1", display: "row 2", value: 1)
    ]
    
    var body: some View {
        List(topTrends.trends) { trend  in
            NavigationLink(destination: NavigationLazyView(TrendDetail(trend: trend))) {
                TrendRow(model: trend)
            }
            
        }
        .navigationBarTitle("Trends")
    }
}


struct TrendList_Previews: PreviewProvider {
    static var previews: some View {
        TrendList()
    }
}


private class TopTrendsObservable: ObservableObject {
    
    @Published var trends = [TrendItem]()
    private var subscribers = Set<AnyCancellable>()
    
    let client = TrendingClient()
    
    init() {
        client.getTop().sink { (error) in
            print("Handle error \(error)")
        } receiveValue: { (trends) in
            self.trends = trends
        }.store(in: &subscribers)

    }
    
}
