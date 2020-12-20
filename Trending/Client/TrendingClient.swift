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

struct IdItem<T>: Decodable, Identifiable where T: Decodable, T: Hashable {
    let id: T
}

struct OptionnalIdItem: Decodable {
    let id: UUID?
}

struct TwitterDataPoint: Decodable, Identifiable {
    let id: UUID
    let value: Int64
    let createdAt: TimeInterval
    let place: IdItem<Int32>
    
}

struct TrendDetails: Decodable {
    let trend: TrendItem
    let history: [TwitterDataPoint]
    
}

enum NetworkError: Error {
    case serverError
}

struct Place: Decodable, Identifiable {
    let id: Int32
    let name: String
    let country: OptionnalIdItem?
}

struct TrendingClient: ServiceType {

    let network: RouterClient
    
    static func make(_ resolver: Resolver) -> TrendingClient {
        return TrendingClient(network: resolver.resolve(RouterClient.self)!)
    }
    
    func getTop(seconds: TimeInterval, placeId: Int32?) -> Future<[TrendItem],Error> {
        var queryParams = ["seconds":"\(seconds)"]
        if let placeId = placeId {
            queryParams["placeId"] = "\(placeId)"
        }
        return network.route(named: "top_trends",querySubstitutions: queryParams)
    }
    
    func getDetails(id: UUID, seconds: TimeInterval) -> Future<TrendDetails, Error> {
        let queryParams = ["seconds":"\(seconds)"]
        return network.route(named: "trend_details_id", pathSubstitutions: ["id":id.uuidString], querySubstitutions: queryParams)
    }
    
    func getPlaces() -> Future<[Place], Error> {
        var request = RouteRequest(name: "places")
        request.stubPath = "Stubs/place/get_places.json"
        return network.route(request: request)
    }
    
}
