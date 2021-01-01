//
//  LoadingIndicator.swift
//  Trending
//
//  Created by Alexander Skorulis on 30/12/20.
//

import Foundation
import SwiftUI

struct LoadingIndicator: View {
    
    var body: some View {
        return VStack {
            Spacer(minLength: 50)
            HStack {
                Spacer()
                ProgressView()
                Spacer()
            }
            Spacer(minLength: 50)
        }
    }
}
