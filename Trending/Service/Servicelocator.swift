//  Created by Alexander Skorulis on 6/12/20.


import Foundation
import Swinject

protocol ServiceType {
    static func make(_ resolver: Resolver) -> Self
}

extension Container {
    
    func register<S>(_ type: S.Type = S.self) where S: ServiceType {
        register(S.self) { (resolver) -> S in
            return S.make(resolver)
        }
    }
}

extension Resolver {
    
    func res<S>(_ type: S.Type = S.self) -> S? {
        return resolve(type)
    }
    
}

class Servicelocator: ObservableObject {
    
    let container: Container = Container()
    
    init() {
        container.register(NetworkClient.self)
        container.register(TrendingClient.self)
        
        //Observables
        container.register(TopTrendsObservable.self)
    }
    
    func resolve<S>(_ type: S.Type = S.self) -> S? {
        return container.resolve(type)
    }
    
}