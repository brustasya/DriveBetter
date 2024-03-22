//
//  ObservableVariable.swift
//  TinkoffApp
//
//  Created by Станислава on 14.02.2024.
//

import Foundation
import Combine

class ObservableVariable<T> {
    public var value: T {
        didSet {
            publisher.send(value)
        }
    }
    
    private let publisher = PassthroughSubject<T, Never>()
    
    var valuePublisher: AnyPublisher<T, Never> {
        publisher.eraseToAnyPublisher()
    }
    
    init(_ initialValue: T) {
        value = initialValue
    }
    
    func updateValue(_ newValue: T) {
        value = newValue
    }
}
