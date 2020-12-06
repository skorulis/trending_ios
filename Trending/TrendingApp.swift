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
        services.resolve(RouterClient.self)?.loadRoutes()
        return WindowGroup {
            ContentView(locator: services).environmentObject(services)
        }
    }
}
