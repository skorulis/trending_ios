//
//  TrendingApp.swift
//  Trending
//
//  Created by Alexander Skorulis on 5/12/20.
//

import SwiftUI

@main
struct TrendingApp: App {
    var body: some Scene {
        let services = Servicelocator()
        return WindowGroup {
            ContentView(locator: services).environmentObject(services)
        }
    }
}
