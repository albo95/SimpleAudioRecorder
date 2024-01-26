//
//  DateExtension.swift
//  SimpleAudioRecorder
//
//  Created by Alberto Bruno on 23/01/24.
//

import Foundation

extension Date {
    func formattedString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy-HH.mm.ss"
        return dateFormatter.string(from: self)
    }
}
