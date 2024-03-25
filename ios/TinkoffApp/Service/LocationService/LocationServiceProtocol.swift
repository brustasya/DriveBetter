//
//  LocationServiceProtocol.swift
//  TinkoffApp
//
//  Created by Станислава on 25.03.2024.
//

import Foundation

protocol LocationServiceProtocol: AnyObject {
    var currentSpeed: ObservableVariable<Double> { get }
    var maxSpeed: ObservableVariable<Double> { get }
    var averageSpeed: ObservableVariable<Double> { get }
}
