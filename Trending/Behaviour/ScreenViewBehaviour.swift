//
//  ScreenViewBehaviour.swift
//  Trending
//
//  Created by Alexander Skorulis on 14/12/20.
//

import Foundation
import SwiftUI

class ScreenViewBehaviour {
    
    let tag: AnalyticsTag
    
    init(tag: AnalyticsTag) {
        self.tag = tag
    }
    
    var modifier: ScreenViewModifier {
        return ScreenViewModifier(tag: tag)
    }
    
    
}


struct ScreenViewModifier: ViewModifier {
    
    let tag: AnalyticsTag
    
    init(tag: AnalyticsTag) {
        self.tag = tag
    }
    
    func body(content: Content) -> some View {
        return content.onAppear(perform: {
            tag.track()
        })
        .eraseToAnyView()
    }
}
