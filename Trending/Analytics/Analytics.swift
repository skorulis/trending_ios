//
//  AnalyticsTagProtocol.swift
//  Trending
//
//  Created by Alexander Skorulis on 14/12/20.
//

import Foundation

struct Analytics {

}

protocol AnalyticsTag {
    var pagename: String { get }
}

extension AnalyticsTag {
    func track() {
        AmplitudeLogger.track(tag: self)
        print("Track: \(pagename)")
    }
}

extension RawRepresentable where RawValue == String, Self: AnalyticsTag {
    var pagename: String {
        return self.rawValue
    }
}
