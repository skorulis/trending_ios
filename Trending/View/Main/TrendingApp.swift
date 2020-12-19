//
//  TrendingApp.swift
//  Trending
//
//  Created by Alexander Skorulis on 5/12/20.
//

import SwiftUI
import Amplitude_iOS
import AppCenter
import AppCenterAnalytics
import AppCenterCrashes

@main
struct TrendingApp: App {
    
    let services = Servicelocator()
    
    init() {
        Amplitude.instance()?.initializeApiKey("95bb76f8d4d0de8d3ced8ee89467b692")
        AppCenter.start(withAppSecret: "3214b0bc-3a73-465a-91d4-c76a9e061db5", services:[
            AppCenterAnalytics.Analytics.self,
          Crashes.self
        ])
    }
    
    var body: some Scene {
        return WindowGroup {
            ContentView(locator: services).environmentObject(services)
        }
    }
}
