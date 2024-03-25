//
//  RatingViewInput.swift
//  TinkoffApp
//
//  Created by Станислава on 19.03.2024.
//

import Foundation

protocol RatingViewInput: AnyObject {
    func applySnapshot(with models: [RatingModel])
}
