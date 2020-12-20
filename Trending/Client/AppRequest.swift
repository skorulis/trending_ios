//
//  AppRequest.swift
//  Trending
//
//  Created by Alexander Skorulis on 20/12/20.
//

import Foundation

struct AppRequest {
    
    var urlRequest: URLRequest
    var stubPath: String?
    
    init(url: URL) {
        self.urlRequest = URLRequest(url: url)
    }
    
}
