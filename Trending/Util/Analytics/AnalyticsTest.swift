//
//  AnalyticsTest.swift
//  Trending
//
//  Created by Alexander Skorulis on 14/12/20.
//

import Foundation
import SwiftUI

struct ScreenViewAnalytics: ViewModifier {
    
    let pageName: String
    
    init(pageName: String) {
        self.pageName = pageName
    }
    
    func body(content: Content) -> some View {
        return content.onAppear(perform: {
            print("Do some logging here")
        })
    }
}
