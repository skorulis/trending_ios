//
//  TrendDetail.swift
//  Trending
//
//  Created by Alexander Skorulis on 5/12/20.
//

import Foundation
import SwiftUI
import Combine

struct TrendDetail: View {
    
    let trend: TrendItem
    @ObservedObject private var trendDetails: TrendDetailObservable
    
    init(trend: TrendItem) {
        self.trend = trend
        print("x: \(trend.display)")
        trendDetails = TrendDetailObservable(trend: trend)
    }
    
    var body: some View {
        VStack {
            TrendChartView(data: trendDetails.details?.history ?? [])
        }
        .navigationBarTitle(trend.display)
    }
    
}

private class TrendDetailObservable: ObservableObject {
    
    @Published var details: TrendDetails?
    private var subscribers = Set<AnyCancellable>()
    
    let client = TrendingClient()
    
    init(trend: TrendItem) {
        client.getDetails(id: trend.id).sink { (completion) in
            print("Handle error \(completion)")
        } receiveValue: { (details) in
            print("GOt details")
            self.details = details
        }.store(in: &subscribers)

    }
    
}
