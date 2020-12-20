//
//  NetworkClient.swift
//  Trending
//
//  Created by Alexander Skorulis on 6/12/20.
//

import Foundation
import Combine
import Swinject

class NetworkClient {
    
    private let session: URLSession
    var subscibers: Set<AnyCancellable> = []
    var debugResponseProvider: DebugResponseProvider?
    
    init() {
        self.session = URLSession(configuration: .default)
    }
    
    func execute<ResultType>(appRequest: AppRequest) -> Future<ResultType, Error> where ResultType: Decodable {
        if let debugResponse = debugResponseProvider?.getResponse(request: appRequest) {
            return Future<ResultType,Error> { (promise) in
                do {
                    let result = try JSONDecoder().decode(ResultType.self, from: debugResponse.data)
                    DispatchQueue.main.async {
                        promise(.success(result))
                    }
                } catch {
                    promise(.failure(error))
                }
                
            }
        }
        
        return execute(request: appRequest.urlRequest)
    }
    
    func execute<ResultType>(request: URLRequest) -> Future<ResultType, Error> where ResultType: Decodable {
        print("\(request.httpMethod ?? "GET") \(request.url!)")
        return Future<ResultType,Error> { (promise) in
            self.session.dataTaskPublisher(for: request).tryMap { (data, response) -> Data in
                if let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 400 {
                    throw NetworkError.serverError
                }
                return data
            }.decode(type: ResultType.self, decoder: JSONDecoder())
            .receive(on: RunLoop.main)
            .sink { (completion) in
                
                switch completion {
                case .failure(let error):
                    promise(.failure(error))
                case .finished:
                    break //TODO: Logging?
                }
            } receiveValue: { (items) in
                promise(.success(items))
            }.store(in: &self.subscibers)
        }
    }
    
    func get<ResultType>(url: URL) -> Future<ResultType, Error> where ResultType: Decodable {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        return execute(request: request)
    }
    
}
