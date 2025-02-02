//
//  DoubleExtension.swift
//  TinkoffApp
//
//  Created by Станислава on 25.03.2024.
//

import Foundation

extension Double {
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
