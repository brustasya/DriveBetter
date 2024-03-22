//
//  TripModel.swift
//  TinkoffApp
//
//  Created by Станислава on 13.03.2024.
//

import Foundation

struct TripModel: Hashable {
    let uuid = UUID()
    let date: Date
    let city: String
    let rating: Double
    let isDriver: Bool
}
