//
//  MainScreenViewOutput.swift
//  TinkoffApp
//
//  Created by Станислава on 08.02.2024.
//

import Foundation

protocol MainScreenViewOutput: AnyObject {
    func tripDidSelect(model: TripModel)
    func viewWillAppear()
}
