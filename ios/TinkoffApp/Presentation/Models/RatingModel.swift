//
//  RatingModel.swift
//  TinkoffApp
//
//  Created by Станислава on 19.03.2024.
//

import Foundation

struct RatingModel: Hashable {
    let uuid = UUID()
    let place: Int
    let name: String
    let city: String
}
