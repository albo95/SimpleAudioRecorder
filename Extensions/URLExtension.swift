//
//  UrlExtension.swift
//  SimpleAudioRecorder
//
//  Created by Alberto Bruno on 15/02/24.
//

import Foundation

extension URL {
    var isDirectory: Bool {
       (try? resourceValues(forKeys: [.isDirectoryKey]))?.isDirectory == true
    }
}
