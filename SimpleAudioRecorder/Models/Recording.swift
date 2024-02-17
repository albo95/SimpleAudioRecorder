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
    var duration: TimeInterval = 0
    var elapsedTime: TimeInterval = 0
    @Attribute(.externalStorage)
    var audioData: Data?
    
    init(fileURL: URL, name: String? = "", dateOfRecording: Date? = nil, isPlaying: Bool = false, duration: TimeInterval = 0, elapsedTime: TimeInterval = 0, audioData: Data? = nil) {
        self.fileURL = fileURL
        self.name = (name == "" ? fileURL.lastPathComponent : name ?? "")
        self.dateOfRecording = dateOfRecording
        self.isPlaying = isPlaying
        self.duration = duration
        self.elapsedTime = elapsedTime
        self.audioData = audioData
    }
    
    static var emptyRecording: Recording =  Recording(fileURL: URL(fileURLWithPath: "Documents/prova 123"), name: "Prova", dateOfRecording: Date.now, duration: 100)
    
    func reset() {
        self.isPlaying = false
        self.elapsedTime = 0
    }
}
