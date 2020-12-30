//
//  RouterClient.swift
//  Trending
//
//  Created by Alexander Skorulis on 6/12/20.
//

import Foundation
import Combine
import Swinject
import ASNetworking

struct RouteModel: Decodable {
    let path: String
    let method: String
    let queryParams: [String: String]?
}

struct RouterClientModel: Decodable {
    
    let routes: [String: RouteModel]
    
}

extension Future {
    
    static func reject(_ error: Failure) -> Future<Output, Failure> {
        return Future { (promise) in
            promise(.failure(error))
        }
    }
}

enum RouterError: Error {
    case missingRoute
    case missingPathParam
    case missingQueryParam
    case invalidURL
}

struct RouteRequest {
    
    var name: String
    var pathSubstitutions: [String: String] = [:]
    var querySubstitutions: [String: String] = [:]
    var stubPath: String?
}

final class RouterClient: NetworkClient, ObservableObject, ServiceType {
    
    let baseURL: String
    private var routes = [String:RouteModel]()
    
    @Published var routesLoaded:Bool = false
    
    static func make(_ resolver: Resolver) -> RouterClient {
        let config = resolver.resolve(ConfigService.self)!
        return RouterClient(baseURL: config.mainURL, debugResponseProvider: resolver.resolve(DebugResponseProvider.self))
    }
    
    init(baseURL: String, debugResponseProvider: DebugResponseProvider?) {
        self.baseURL = baseURL
        super.init()
        self.debugResponseProvider = debugResponseProvider
    }
    
    func loadRoutes() -> Future<RouterClientModel, Error> {
        let future: Future<RouterClientModel,Error> = get(url: URL(string: self.baseURL)!)
        future.sink { (completion) in
            if case let .failure(error) = completion {
                print("Failure getting routes \(error)")
            }
        } receiveValue: { (model) in
            self.routes = model.routes
            self.routesLoaded = true
        }.store(in: &subscibers)
        
        return future
    }
    
    func route<S>(request: RouteRequest) -> Future<S,Error> where S: Decodable {
        guard let route = self.routes[request.name] else {
            return Future.reject(RouterError.missingRoute)
        }
        var path = route.path
        for (key, value) in request.pathSubstitutions {
            let lookup = "{\(key)}"
            if !path.contains(lookup) {
                return Future.reject(RouterError.missingPathParam)
            }
            path = path.replacingOccurrences(of: lookup, with: value)
        }
        
        var queryStrings: [String] = []
        for (key, value) in request.querySubstitutions {
            if route.queryParams?[key] == nil {
                return Future.reject(RouterError.missingQueryParam)
            }
            queryStrings.append("\(key)=\(value)")
        }
        if queryStrings.count > 0 {
            path = "\(path)?\(queryStrings.joined(separator: "&"))"
        }
        let urlString = baseURL + path
        guard let url = URL(string: urlString) else {
            return Future.reject(RouterError.invalidURL)
        }
        var appRequest = AppRequest(url: url)
        appRequest.urlRequest.httpMethod = route.method
        appRequest.stubPath = request.stubPath
        return execute(appRequest: appRequest)
    }
    
    func route<S>(named: String, pathSubstitutions: [String: String] = [:], querySubstitutions: [String: String] = [:]) -> Future<S,Error> where S: Decodable {
        var routeRequest = RouteRequest(name: named)
        routeRequest.pathSubstitutions = pathSubstitutions
        routeRequest.querySubstitutions = querySubstitutions
        return route(request: routeRequest)
    }
    
    
}
