//
//  Recording.swift
//  SimpleAudioRecorder
//
//  Created by Alberto Bruno on 23/01/24.
//

import Foundation
import SwiftData

@Model
class Recording {
    var fileURL: URL?
    var name: String = ""
    var dateOfRecording: Date?
    var isPlaying: Bool = false
    var duration: Double?
    var pausedTime: Double?
    @Attribute(.externalStorage)
    var audioData: Data?
    
    init(fileURL: URL, dateOfRecording: Date, isPlaying: Bool = false, duration: Double = 0, currentSec: Double = 0) {
        self.fileURL = fileURL
        self.name = fileURL.lastPathComponent
        self.dateOfRecording = dateOfRecording
        self.isPlaying = isPlaying
        self.duration = duration
    }
    
    static var emptyRecording: Recording =  Recording(fileURL: URL(fileURLWithPath: "Documents/prova 123"), dateOfRecording: Date.now, duration: 100)
    
    func reset() {
        self.isPlaying = false
        self.pausedTime = nil
    }
}
