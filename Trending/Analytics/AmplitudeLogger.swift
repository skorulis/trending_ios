//
//  AmplitudeLogger.swift
//  Trending
//
//  Created by Alexander Skorulis on 14/12/20.
//

import Foundation
import Swinject
import Amplitude_iOS

struct AmplitudeLogger {
    
    static func track(tag: AnalyticsTag) {
        Amplitude.instance()?.logEvent(tag.pagename)
    }
    
}
