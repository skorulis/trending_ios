//
//  Analytics+Trends.swift
//  Trending
//
//  Created by Alexander Skorulis on 14/12/20.
//

import Foundation

extension Analytics {
    
    enum Trends: String, AnalyticsTag {
        ///The user views the list of trends
        case viewList = "Trend:List"
        ///The user views the detail list of trends
        case viewDetail = "Trend:Detail"
    }
    
    enum Places: String, AnalyticsTag {
        ///View the list of places
        case list = "Place:List"
    }
    
}
