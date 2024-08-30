//
//  BatteryState.swift
//  BatteryMonitor
//
//  Created by Kai Azim on 2023-08-23.
//

import Foundation

/// Define the precision, with wich the icon can display the current charging level
public let drawingPrecision = 5.4

/// Defines the state the battery is currently in.
///
/// - chargedAndPlugged: The battery is plugged into a power supply and charged.
/// - charging: The battery is plugged into a power supply and
///             charging. Takes the current percentage as argument.
/// - discharging: The battery is currently discharging. Accepts the
///                current percentage as argument.
enum BatteryState: Equatable {
    case chargedAndPlugged
    case charging(percentage: Percentage)
    case discharging(percentage: Percentage)

    // MARK: Internal

    /// The current percentage.
    var percentage: Percentage {
        switch self {
        case .chargedAndPlugged:
            return Percentage(numeric: 100)
        case .charging(let percentage):
            return percentage
        case .discharging(let percentage):
            return percentage
        }
    }
}

/// Compares two BatteryState for equality.
///
/// - parameter lhs: A BatteryState.
/// - parameter rhs: Another BatteryState.
/// - returns: True if the supplied BatteryStates are equal. Otherwise false.
func == (lhs: BatteryState, rhs: BatteryState) -> Bool {
    switch (lhs, rhs) {
    case (.chargedAndPlugged, .chargedAndPlugged),
         (.charging, .charging):
        return true
    case (.discharging(let lhsPercentage), .discharging(let rhsPercentage)):
        guard let lhs = lhsPercentage.numeric, let rhs = rhsPercentage.numeric else {
            return false
        }
        // Divide the percentages by the defined drawing precision; So that the battery image
        // only gets redrawn, when it actually differs.
        return round(Double(lhs) / drawingPrecision) == round(Double(rhs ) / drawingPrecision)
    default:
        return false
    }
}
