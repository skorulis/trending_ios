//
//  ContentView.swift
//  Trending
//
//  Created by Alexander Skorulis on 5/12/20.
//

import SwiftUI

struct ContentView: View {
    
    private let locator: Servicelocator
    @ObservedObject var routerClient: RouterClient
    
    init(locator: Servicelocator) {
        self.locator = locator
        routerClient = locator.resolve()!
    }
    
    var body: some View {
        if routerClient.routesLoaded {
            TabView {
                NavigationView {
                    TrendList(locator: self.locator)
                }.tabItem { Text("Trends") }
                NavigationView {
                    PlaceListView(locator: self.locator)
                }.tabItem { Text("Places") }
                
                    
            }
            
        } else {
            Text("Loading routes \(routerClient.routesLoaded ? "YES" : "NO" )")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(locator: Servicelocator())
    }
}