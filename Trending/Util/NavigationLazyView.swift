//
//  NavigationLazyView.swift
//  Trending
//
//  Created by Alexander Skorulis on 6/12/20.
//

import SwiftUI

struct NavigationLazyView<Content: View>: View {
    let build: () -> Content
    init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }
    var body: Content {
        build()
    }
}

