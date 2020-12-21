//
//  TrendRow.swift
//  Trending
//
//  Created by Alexander Skorulis on 5/12/20.
//

import Foundation
import SwiftUI

struct TrendRow: View {
    
    var model: TrendItem
    
    var body: some View {
        Text(model.display)
        .eraseToAnyView()
    }
}

struct TrendRow_Previews: PreviewProvider {
    static var previews: some View {
        TrendRow(model: TrendItem(id: UUID(), key: "TEST", display: "Display item", value: 1))
    }
}

