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
    let seconds: TimeInterval
    @ObservedObject private var trendDetails: TrendDetailObservable
    
    init(trend: TrendItem, seconds: TimeInterval, locator: Servicelocator) {
        self.trend = trend
        self.seconds = seconds
        print("x: \(trend.display)")
        trendDetails = TrendDetailObservable(trend: trend, seconds: seconds, locator: locator)
    }
    
    var body: some View {
        VStack {
            TrendChartView(data: trendDetails.details?.history ?? [])
        }
        .navigationBarTitle(trend.display)
    }
    
}

class TrendDetailObservable: ObservableObject {
    
    @Published var details: TrendDetails?
    private var subscribers = Set<AnyCancellable>()
    
    var client: TrendingClient
    let seconds: TimeInterval
    
    init(trend: TrendItem, seconds: TimeInterval, locator: Servicelocator) {
        client = locator.resolve()!
        self.seconds = seconds
        client.getDetails(id: trend.id, seconds: seconds).sink { (completion) in
            print("Handle error \(completion)")
        } receiveValue: { (details) in
            print("GOt details")
            self.details = details
        }.store(in: &subscribers)

    }
    
}
