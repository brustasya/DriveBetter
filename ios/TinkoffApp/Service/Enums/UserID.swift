//
//  UserID.swift
//  TinkoffApp
//
//  Created by Станислава on 25.03.2024.
//

import Foundation
import UIKit

enum UserID {
    static let uuid: String = UIDevice.current.identifierForVendor?.uuidString ?? "\(UUID())"
}
