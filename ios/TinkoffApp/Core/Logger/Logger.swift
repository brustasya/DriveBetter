//
//  Logger.swift
//  TinkoffApp
//
//  Created by Станислава on 13.04.2024.
//

import Foundation

protocol LoggerLogic {
    func printLog(log: String)
}

class Logger: LoggerLogic {
    static let shared: LoggerLogic = Logger()
    
    func printLog(log: String) {
        if CommandLine.arguments.contains("-logs-enabled") {
            print(log)
        }
    }
}
