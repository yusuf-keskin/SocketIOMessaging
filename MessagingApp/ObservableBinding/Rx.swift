//
//  Rx.swift
//  MessagingApp
//
//  Created by YUSUF KESKİN on 8.10.2022.
//

import Foundation

class Rx<T> {
    typealias Observer = (T) -> ()
        
    var observer : Observer?
    
    var value : T {
        didSet {
            observer?(value)
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    func bind ( _ listener : Observer?) {
        self.observer = listener
    }
    
    func subscribe( _ observer : Observer?) {
        self.observer = observer
        observer?(value)
    }
}




