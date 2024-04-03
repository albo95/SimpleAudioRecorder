//
//  DataExtension.swift
//  SimpleAudioRecorder
//
//  Created by Alberto Bruno on 03/04/24.
//

import Foundation

extension Data {
    mutating func appendString(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
