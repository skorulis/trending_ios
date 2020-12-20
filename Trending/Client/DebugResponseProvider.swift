//
//  DebugResponseProvider.swift
//  Trending
//
//  Created by Alexander Skorulis on 20/12/20.
//

import Foundation
import Swinject

struct DebugResponse {
    let data: Data
    var httpStatus: Int = 200
}

protocol DebugResponseProvider {
    func getResponse(request: AppRequest) -> DebugResponse?
}

struct EmptyDebugResponseProvider: DebugResponseProvider, ServiceType {
    
    static func make(_ resolver: Resolver) -> EmptyDebugResponseProvider {
        return EmptyDebugResponseProvider()
    }
    
    func getResponse(request: AppRequest) -> DebugResponse? {
        return nil
    }
    
}

struct RollingDebugResponseProvider: DebugResponseProvider, ServiceType {
    
    static func make(_ resolver: Resolver) -> RollingDebugResponseProvider {
        return RollingDebugResponseProvider()
    }
    
    func getResponse(request: AppRequest) -> DebugResponse? {
        guard let stubPath = request.stubPath else {
            return nil
        }
        guard let url = Bundle.main.url(forResource: stubPath, withExtension: nil) else {
            return nil
        }
        
        guard let data = try? Data(contentsOf: url) else {
            return nil
        }
        
        return DebugResponse(data: data)
        
    }
    
}
