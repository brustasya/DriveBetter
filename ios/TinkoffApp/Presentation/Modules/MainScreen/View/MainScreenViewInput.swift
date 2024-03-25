//
//  MainScreenViewInput.swift
//  TinkoffApp
//
//  Created by Станислава on 08.02.2024.
//

import Foundation

protocol MainScreenViewInput: AnyObject {
    func applySnapshot(tripModels: [TripModel])
    func stopRefreshing() 
}
