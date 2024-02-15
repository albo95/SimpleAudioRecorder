//
//  RecordingLabelView.swift
//  SimpleAudioRecorder
//
//  Created by Alberto Bruno on 24/01/24.
//

import SwiftUI

struct RecordingLabelView: View {
    var recording: Recording
    private var myLogger: MyLogger = MyLogger.shared
    private var audioPlayerManager: AudioPlayerManager //TODO: forse va messa come variabile environment
    
    init(recording: Recording) {
        self.recording = recording
        self.audioPlayerManager = AudioPlayerManager.shared
    }
    
    var body: some View {
        HStack {
            Button(action: {
                recording.isPlaying.toggle()
                recording.isPlaying ? startPlaying() : stopPlaying()
            }, label: {
                Image(systemName: recording.isPlaying ? "pause.fill" : "play.fill")
                    .foregroundStyle(.red)
                    .font(.system(size: 26))
                
            }).padding(.trailing, 20)
            Text(recording.name)
                .font(.system(size: 16))
        }
    }
    
    private func startPlaying() {
        if let fileURL = recording.fileURL {
            myLogger.addLog("try to play: \(fileURL)")
            if FileManager.default.fileExists(atPath: fileURL.path) {  
                myLogger.addLog("Il file è in memoria locale")
                audioPlayerManager.startPlaying(url: fileURL)
            } else if let fileData = recording.audioData {
                myLogger.addLog("Il file non è in memoria locale", .error)
                do {
                    let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                    let fileURL = path.appendingPathComponent(recording.name)
                    try fileData.write(to: fileURL, options: .atomic)
                    recording.fileURL = fileURL
                    audioPlayerManager.startPlaying(url: fileURL)
                } catch {
                    myLogger.addLog(error.localizedDescription)
                }
            }
        }
    }
    
    private func stopPlaying() {
        audioPlayerManager.stopPlaying()
    }
}

#Preview {
    RecordingLabelView(recording: Recording(fileURL: URL(fileURLWithPath: "Documents/prova 123"), dateOfRecording: Date.now))
}
