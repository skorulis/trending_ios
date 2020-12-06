//
//  TrendingClient.swift
//  Trending
//
//  Created by Alexander Skorulis on 5/12/20.
//

import UIKit
import Combine
import Swinject

struct TrendItem: Decodable, Hashable, Identifiable {
    let id: UUID
    let key: String
    let display: String
    let value: Int64?
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct IdItem: Decodable, Identifiable {
    let id: UUID
}

struct TwitterDataPoint: Decodable, Identifiable {
    let id: UUID
    let value: Int64
    let createdAt: TimeInterval
    let place: IdItem
    
}

struct TrendDetails: Decodable {
    let trend: TrendItem
    let history: [TwitterDataPoint]
    
}

enum NetworkError: Error {
    case serverError
}

struct TrendingClient: ServiceType {

    let network: RouterClient
    
    static func make(_ resolver: Resolver) -> TrendingClient {
        return TrendingClient(network: resolver.resolve(RouterClient.self)!)
    }
    
    func getTop() -> Future<[TrendItem],Error> {
        return network.route(named: "top_trends")
    }
    
    func getDetails(id: UUID) -> Future<TrendDetails, Error> {
        return network.route(named: "trend_details_id", pathSubstitutions: ["id":id.uuidString])
    }
    
}
