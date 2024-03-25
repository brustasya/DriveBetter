//
//  Colors.swift
//  TinkoffApp
//
//  Created by Станислава on 25.03.2024.
//

import UIKit

enum Colors: String, CaseIterable, Codable, Equatable {
    case yellow = "#fcdc2c"
    case red = "#FF4040"
    case lightBlue = "#65A6D1"
    case blue = "#3E97D1"
    case darkBlue = "#03426A"
    case gold = "#ffd900"
    case silver = "#808080"
    case brown = "#cd7f32"
    
    var uiColor: UIColor {
        return UIColor(rgb: self.rawValue) ?? .white
    }
}
