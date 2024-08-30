//
//  PowerSource.swift
//  BatteryMonitor
//
//  Created by Kai Azim on 2023-08-23.
//

import Foundation

enum PowerSource: String {
    case unknown = "Unknown"
    case powerAdapter = "Power Adapter"
    case battery = "Battery"

    var localizedDescription: String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
}
