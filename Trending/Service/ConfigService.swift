//
//  ConfigService.swift
//  Trending
//
//  Created by Alexander Skorulis on 30/12/20.
//

import Foundation
import Swinject

protocol ConfigService {
    
    var mainURL: String { get }
    
}

struct ProdConfigService: ConfigService, ServiceType {
    
    static func make(_ resolver: Resolver) -> ProdConfigService {
        return ProdConfigService()
    }
    
    var mainURL: String {
        return "http://trending.skorulis.com:7000/"
    }
    
}

struct DebugConfigService: ConfigService, ServiceType {
    
    static func make(_ resolver: Resolver) -> DebugConfigService {
        return DebugConfigService()
    }
    
    //MARK: Keys
    
    static let kMainURLKey = "kMainURLKey"
    
    enum MainURLOption: Int {
        case remote = 0
        case local = 1
        
        var url: String {
            switch self {
            case .remote:
                return "http://trending.skorulis.com:7000/"
            case .local:
                return "http://localhost:7000/"
            }
        }
    }
    
    var mainURL: String {
        let option = UserDefaults.standard.integer(forKey: DebugConfigService.kMainURLKey)
        return (MainURLOption(rawValue: option) ?? MainURLOption.remote).url
    }
}
