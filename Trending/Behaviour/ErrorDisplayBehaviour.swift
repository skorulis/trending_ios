//
//  ErrorDisplayBehaviour.swift
//  Trending
//
//  Created by Alexander Skorulis on 14/12/20.
//

import Foundation
import SwiftUI
import Combine

class ErrorDisplayBehaviour: ObservableObject, BehaviourProtocol {
    @Published var error: Error? //The error to be displayed
    var subscribers = Set<AnyCancellable>()
    var retryHandler: (() -> Void)?
    
    init(retryHandler: (() -> Void)? = nil) {
        self.retryHandler = retryHandler
    }
    
    func handle<T>(_ publisher: Future<T,Error>) {
        self.error = nil //Clear out the old error
        publisher.sink { (completion) in
            if case let Subscribers.Completion.failure(error) = completion {
                self.error = error
            }
        } receiveValue: { (_) in
            //No action
        }.store(in: &subscribers)

    }
    
    var modifier: ErrorEmittingViewModifier {
        return ErrorEmittingViewModifier(error: error, retryHandler: retryHandler)
    }
    
}
