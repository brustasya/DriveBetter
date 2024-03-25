//
//  PassengerTripViewOutput.swift
//  TinkoffApp
//
//  Created by Станислава on 17.03.2024.
//

import Foundation

protocol PassengerTripViewOutput: AnyObject {
    func closeButtonTapped()
    func viewIsReady()
    func changeRoleButtonTapped()
}
