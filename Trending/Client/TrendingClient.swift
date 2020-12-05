//
//  TrendingClient.swift
//  Trending
//
//  Created by Alexander Skorulis on 5/12/20.
//

import UIKit
import Combine

struct TrendItem: Decodable, Hashable, Identifiable {
    let id: UUID
    let key: String
    let display: String
    let value: Int64
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
}

enum NetworkError: Error {
    case serverError
}

class TrendingClient {

    private let session: URLSession
    private var subscibers: Set<AnyCancellable> = []
    
    init() {
        self.session = URLSession(configuration: .default)
    }
    
    func getTop() -> Future<[TrendItem],Error> {
        let url = URL(string: "http://localhost:7000/trend/top")!
        return Future<[TrendItem],Error> { (promise) in
            self.session.dataTaskPublisher(for: url).tryMap { (data, response) -> Data in
                if let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 400 {
                    throw NetworkError.serverError
                }
                return data
            }.decode(type: [TrendItem].self, decoder: JSONDecoder())
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
