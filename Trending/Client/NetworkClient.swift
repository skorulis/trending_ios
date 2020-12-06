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
    
    init() {
        self.session = URLSession(configuration: .default)
    }
    
    func get<ResultType>(url: URL) -> Future<ResultType, Error> where ResultType: Decodable {
        print("Get \(url)")
        return Future<ResultType,Error> { (promise) in
            self.session.dataTaskPublisher(for: url).tryMap { (data, response) -> Data in
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
    
}
