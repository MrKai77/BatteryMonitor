//
//  BatteryMonitorApp.swift
//  BatteryMonitor
//
//  Created by Kai Azim on 2023-12-12.
//

import SwiftUI
import DynamicNotchKit

@main
struct BatteryMonitorApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        MenuBarExtra("Battery Monitor", systemImage: "minus.plus.batteryblock.fill") {
            Button(action: {
                appDelegate.updateBatteryInfo()

                if !appDelegate.dynamicNotch.isVisible {
                    appDelegate.dynamicNotch = DynamicNotchInfo(
                        iconView: ProgressRing(to: .constant(appDelegate.batteryPercentage), color: .green),
                        title: "Battery Percentage",
                        description: "\(appDelegate.batteryTimeRemaining)"
                    )
                    appDelegate.dynamicNotch.show(for: 2)
                }
            },
                   label: {
                Text("Trigger")
            })
            Button(action: {
                NSApp.terminate(self)
            }, label: {
                Text("Quit")
            })
        }
        .menuBarExtraStyle(.menu)
   }
}

class AppDelegate: NSObject, NSApplicationDelegate, ObservableObject {

    private var batteryService: BatteryService?
    var dynamicNotch: DynamicNotch

    @Published var batteryPercentage: CGFloat = 0
    @Published var isPowerSourceBattery = true
    @Published var batteryTimeRemaining: String = ""

    let CHARGING_THRESHOLD = 0.20

    override init() {
        // Simply initialize this value since it's not allowed to be nil (since it's not an optional)
        self.dynamicNotch = DynamicNotchInfo(
            iconView: ProgressRing(to: .constant(0), color: .yellow),
            title: "PLACEHOLDER"
        )
    }

   func applicationDidFinishLaunching(_ notification: Notification) {
       do {
           try self.batteryService = BatteryService()
       } catch {
           batteryService = nil
       }

       self.updateBatteryInfo()

       // Listen for power source changes
       NotificationCenter.default.addObserver(forName: .powerSourceChangedNotification, object: nil, queue: .main) { _ in
           self.updateBatteryInfo()
       }
    }

    func updateBatteryInfo() {
        var overrideWillShowPopup = false

        guard let batteryService = self.batteryService else {
            return
        }

        // Show popup when the power cable is plugged in/out
        if self.isPowerSourceBattery != (batteryService.powerSource != .powerAdapter) {
            overrideWillShowPopup = true
        }

        // Fetch battery information
        self.isPowerSourceBattery = batteryService.powerSource != .powerAdapter
        self.batteryTimeRemaining = batteryService.timeRemaining.formatted
        self.batteryPercentage = CGFloat(batteryService.percentage.numeric ?? 0) / 100

        // Show popup when the battery is low, so that user remembers to charge their computer
        if (batteryPercentage <= CHARGING_THRESHOLD && isPowerSourceBattery) {
            self.dynamicNotch = DynamicNotchInfo(
                iconView: ProgressRing(to: .constant(self.batteryPercentage), color: batteryPercentage <= CHARGING_THRESHOLD ? .red : .green),
                title: "Low Battery",
                description: "Please charge this MacBook to dismiss this warning."
            )

            if !self.dynamicNotch.isVisible {
                dynamicNotch.show()
            }
        } else if overrideWillShowPopup {
            self.dynamicNotch = DynamicNotchInfo(
                iconView: ProgressRing(to: .constant(self.batteryPercentage), color: .green),
                title: "Battery Percentage",
                description: "\(self.batteryTimeRemaining)"
            )

            // Adding 0.5 seconds makes this smoother because the app seems to freeze for
            // a split second when the power adapter is plugged in (This is a macOS issue)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.dynamicNotch.show(for: 5)
            }
        }
    }
}
