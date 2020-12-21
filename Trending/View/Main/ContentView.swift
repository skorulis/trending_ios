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
            Text("Loading routes")
                .modifier(viewModel.errorBehaviour.modifier)
        }
    }
}

extension ContentView {
    class ViewModel: ObservableObject {
        
        @Published var routerClient: RouterClient
        private var subscribers = Set<AnyCancellable>()
        private var behaviours = BehaviourContainer()
        let errorBehaviour = ErrorDisplayBehaviour()
        
        init(locator: Servicelocator) {
            routerClient = locator.resolve()!
            errorBehaviour.retryHandler = {
                self.load()
            }
            
            errorBehaviour.objectWillChange.sink { (_) in
                self.objectWillChange.send()
            }.store(in: &subscribers)
            
            routerClient.objectWillChange.sink { (_) in
                self.objectWillChange.send()
            }.store(in: &subscribers)
            load()
        }
        
        func load() {
            errorBehaviour.handle(routerClient.loadRoutes())
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(locator: Servicelocator())
    }
}
