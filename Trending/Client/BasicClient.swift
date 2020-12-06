//
//  BasicClient.swift
//  Trending
//
//  Created by Alexander Skorulis on 6/12/20.
//

import Foundation
import Swinject

final class BasicClient: NetworkClient, ServiceType {
    
    static func make(_ resolver: Resolver) -> BasicClient {
        return BasicClient()
    }
    
}
