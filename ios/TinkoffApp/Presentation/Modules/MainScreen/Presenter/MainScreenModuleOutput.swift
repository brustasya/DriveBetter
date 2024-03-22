//
//  MainScreenModuleOutput.swift
//  TinkoffApp
//
//  Created by Станислава on 08.02.2024.
//

import Foundation

protocol MainScreenModuleOutput: AnyObject {
    func moduleWantsToOpenTrip(with model: TripModel)
}
