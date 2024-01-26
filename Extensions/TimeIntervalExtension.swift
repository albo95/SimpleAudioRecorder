//
//  TimeIntervalExtension.swift
//  SimpleAudioRecorder
//
//  Created by Alberto Bruno on 24/01/24.
//

import Foundation

extension TimeInterval {
    func toMinutesSeconds() -> String {
        let totalSeconds = abs(Int(self))
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}
