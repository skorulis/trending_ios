//
//  DebugResponseProvider.swift
//  Trending
//
//  Created by Alexander Skorulis on 20/12/20.
//

import Swinject
import ASNetworking

extension EmptyDebugResponseProvider: ServiceType {
    
    static func make(_ resolver: Resolver) -> EmptyDebugResponseProvider {
        return EmptyDebugResponseProvider()
    }
    
}

extension RollingDebugResponseProvider: ServiceType {
        
    static func make(_ resolver: Resolver) -> RollingDebugResponseProvider {
        return RollingDebugResponseProvider()
    }
    
}
