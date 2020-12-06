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
            if case let .failure(error) = completion {
                print("Failure getting routes \(error)")
            }
        } receiveValue: { (model) in
            self.routes = model.routes
            self.routesLoaded = true
        }.store(in: &subscibers)
    }
    
    func route<S>(named: String, pathSubstitutions: [String: String] = [:], querySubstitutions: [String: String] = [:]) -> Future<S,Error> where S: Decodable {
        guard let route = self.routes[named] else {
            return Future.reject(RouterError.missingRoute)
        }
        var path = route.path
        for (key, value) in pathSubstitutions {
            let lookup = "{\(key)}"
            if !path.contains(lookup) {
                return Future.reject(RouterError.missingPathParam)
            }
            path = path.replacingOccurrences(of: lookup, with: value)
        }
        
        var queryStrings: [String] = []
        for (key, value) in querySubstitutions {
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
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = route.method
        return execute(request: urlRequest)
    }
    
    
}
