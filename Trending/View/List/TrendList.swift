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
    
    @Published var trends = [TrendItem]()
    @Published var timeIndex: Int = 0 {
        didSet {
            print("SEt value")
            getTrends()
        }
    }
    
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
    
    init(client: TrendingClient) {
        self.client = client
        getTrends()
    }
    
    func getTrends() {
        client.getTop(seconds: seconds).sink { (error) in
            print("Handle error \(error)")
        } receiveValue: { (trends) in
            self.trends = trends
        }.store(in: &subscribers)
    }
    
}

struct TrendList: View {
    
    @ObservedObject private var viewModel: TrendListViewModel
    
    private let locator: Servicelocator
    
    init(locator: Servicelocator) {
        self.locator = locator
        viewModel = TrendListViewModel(client: locator.resolve()!)
    }
    
    private var header: some View {
        Picker(selection: $viewModel.timeIndex, label: Text("Picker")) {
            Text("24hr").tag(0)
            Text("12hr").tag(1)
            Text("1hr").tag(2)
        }.pickerStyle(SegmentedPickerStyle())
        
    }
    
    var body: some View {
        List {
            Section(header: header) {
                ForEach(viewModel.trends, id: \.self) { trend in
                    return NavigationLink(destination: NavigationLazyView(TrendDetail(trend: trend, seconds: viewModel.seconds, locator: locator))) {
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
