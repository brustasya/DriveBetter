//
//  DashboardViewInput.swift
//  TinkoffApp
//
//  Created by Станислава on 10.03.2024.
//

import Foundation

protocol DashboardViewInput: AnyObject {
    func updateCurrentSpeed(speed: Int)
    func updateAverageSpeed(speed: Int)
    func updateMaxSpeed(speed: Int)
}
