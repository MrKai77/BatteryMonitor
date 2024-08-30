//
//  Percentage.swift
//  BatteryMonitor
//
//  Created by Kai Azim on 2023-08-23.
//

import Foundation

struct Percentage {
    var numeric: Int?

    var formatted: String {
        guard let percentage = numeric else {
            return NSLocalizedString("Calculating", comment: "")
        }

        let percentageFormatter = NumberFormatter()
        percentageFormatter.numberStyle = .percent
        percentageFormatter.generatesDecimalNumbers = false
        percentageFormatter.localizesFormat = true
        percentageFormatter.multiplier = 1.0
        percentageFormatter.minimumFractionDigits = 0
        percentageFormatter.maximumFractionDigits = 0

        return percentageFormatter.string(from: percentage as NSNumber) ?? "\(percentage) %"
    }
}
