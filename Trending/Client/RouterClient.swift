//
//  RouterClient.swift
//  Trending
//
//  Created by Alexander Skorulis on 6/12/20.
//

import Foundation
import Combine
import Swinject

fileprivate struct RouteModel: Decodable {
    let path: String
    let method: String
    let queryParams: [String: String]?
}

fileprivate struct RouterClientModel: Decodable {
    
    let routes: [String: RouteModel]
    
}

final class RouterClient: NetworkClient, ObservableObject {
    
    let baseURL: String
    private var routes = [String:RouteModel]()
    
    @Published var routesLoaded:Bool = false
    
    init(baseURL: String) {
        self.baseURL = baseURL
    }
    
    func loadRoutes() {
        let future: Future<RouterClientModel,Error> = get(url: URL(string: self.baseURL)!)
        future.sink { (completion) in
            print("Failure getting routes \(completion)")
        } receiveValue: { (model) in
            self.routes = model.routes
            self.routesLoaded = true
        }.store(in: &subscibers)

    }
}
