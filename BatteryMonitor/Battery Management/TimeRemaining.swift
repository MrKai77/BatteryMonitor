//
//  TimeRemaining.swift
//  BatteryMonitor
//
//  Created by Kai Azim on 2023-08-23.
//

import Foundation

struct TimeRemaining {
    let minutes: Int?
    let state: BatteryState?

    var formatted: String {
        guard let minutesRemaining = minutes, let batteryState = state else {
            return NSLocalizedString("Calculating Time Remaining...", comment: "")
        }

        if batteryState == .chargedAndPlugged {
            return NSLocalizedString("Fully Charged!", comment: "")
        }

        return String(format: "%d:%02d Remaining", arguments: [minutesRemaining / 60, minutesRemaining % 60])
    }
}
