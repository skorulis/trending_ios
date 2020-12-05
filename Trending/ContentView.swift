//
//  ContentView.swift
//  Trending
//
//  Created by Alexander Skorulis on 5/12/20.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            TrendList()
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
