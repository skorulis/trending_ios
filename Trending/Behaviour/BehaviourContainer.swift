//
//  BehaviourContainer.swift
//  Trending
//
//  Created by Alexander Skorulis on 14/12/20.
//

import Foundation
import SwiftUI

/*struct AnyBehaviour<Modifier>: BehaviourProtocol where Modifier: ViewModifier {
    //private let inner: BehaviourProtocol
    
    private let _modifier: () -> Modifier
    
    init<T>(_ behaviour: T) where T: BehaviourProtocol, T.ModifierType == Modifier {
        _modifier = behaviour.modifier
    }
    
    func modifier() -> some ViewModifier {
        
        return _modifier()
    }
}*/

class BehaviourContainer: ObservableObject {
    
    var behaviours: [BehaviourProtocol] = []
    
    func replace(_ behaviour: BehaviourProtocol) {
        for i in 0..<behaviours.count {
            if type(of: behaviours[i]) == type(of: behaviour) {
                behaviours[i] = behaviour
                return
            }
        }
        behaviours.append(behaviour)
    }
    
    func find<T>(_ type: T.Type = T.self) -> T? {
        return behaviours.first(where: { $0 is T}) as? T
    }
    
}
