//
//  ContentView.swift
//  Trending
//
//  Created by Alexander Skorulis on 5/12/20.
//

import SwiftUI
import Combine

struct ContentView: View {
    
    private let locator: Servicelocator
    @ObservedObject var viewModel: ViewModel
    
    init(locator: Servicelocator) {
        self.locator = locator
        viewModel = ViewModel(locator: locator)
    }
    
    var body: some View {
        if viewModel.routerClient.routesLoaded {
            TabView {
                NavigationView {
                    TrendList(locator: self.locator)
                }.tabItem { Text("Trends") }
                NavigationView {
                    PlaceListView(locator: self.locator)
                }.tabItem { Text("Places") }
            }
            
        } else {
            Text("Loading routes \(viewModel.routerClient.routesLoaded ? "YES" : "NO" )").emittingError(viewModel.error, retryHandler: {
                viewModel.load()
            })
        }
    }
}

extension ContentView {
    class ViewModel: ObservableObject {
        
        @ObservedObject var routerClient: RouterClient
        @Published var error: Error?
        private var subscribers = Set<AnyCancellable>()
        
        init(locator: Servicelocator) {
            routerClient = locator.resolve()!
            load()
        }
        
        func load() {
            self.error = nil
            routerClient.loadRoutes().sink { (completion) in
                print("Something")
                if case let Subscribers.Completion.failure(error) = completion {
                    self.error = error
                }
            } receiveValue: { (_) in
                //No action
            }.store(in: &subscribers)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(locator: Servicelocator())
    }
}
