//
//  ContentView.swift
//  Trending
//
//  Created by Alexander Skorulis on 5/12/20.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var locator: Servicelocator
    
    var body: some View {
        NavigationView {
            TrendList(locator: self.locator)
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
