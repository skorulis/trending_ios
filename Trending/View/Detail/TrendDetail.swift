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
    @ObservedObject private var viewModel: ViewModel
    
    init(trend: TrendItem, seconds: TimeInterval, locator: Servicelocator) {
        self.trend = trend
        self.seconds = seconds
        viewModel = ViewModel(trend: trend, seconds: seconds, locator: locator)
    }
    
    var body: some View {
        VStack {
            TrendChartView(data: viewModel.details?.history ?? [])
        }.emittingError(viewModel.error, retryHandler: {
            viewModel.load()
        })
        .navigationBarTitle(trend.display)
    }
    
}

extension TrendDetail {
    
    class ViewModel: ObservableObject {
        @Published var details: TrendDetails?
        @Published var error: Error?
        private var subscribers = Set<AnyCancellable>()
        
        var client: TrendingClient
        let seconds: TimeInterval
        let trend: TrendItem
        
        init(trend: TrendItem, seconds: TimeInterval, locator: Servicelocator) {
            client = locator.resolve()!
            self.seconds = seconds
            self.trend = trend
            load()
        }
        
        func load() {
            self.error = nil
            client.getDetails(id: trend.id, seconds: seconds).sink { (completion) in
                if case let Subscribers.Completion.failure(error) = completion {
                    self.error = error
                }
                print("Handle error \(completion)")
            } receiveValue: { (details) in
                print("GOt details")
                self.details = details
            }.store(in: &subscribers)
        }
        
    }
}
