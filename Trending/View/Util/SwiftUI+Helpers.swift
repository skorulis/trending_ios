//
//  SwiftUI+Helpers.swift
//  Trending
//
//  Created by Alexander Skorulis on 21/12/20.
//

import Foundation
import SwiftUI

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }

}
#endif

