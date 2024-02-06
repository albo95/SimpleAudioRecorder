//
//  RecordingLabelView.swift
//  SimpleAudioRecorder
//
//  Created by Alberto Bruno on 24/01/24.
//

import SwiftUI

struct RecordingLabelView: View {
    var recording: Recording
    private var audioPlayerManager: AudioPlayerManager //TODO: forse va messa come variabile environment
    
    init(recording: Recording) {
        self.recording = recording
        self.audioPlayerManager = AudioPlayerManager.shared
    }
    
    var body: some View {
        HStack {
            Button(action: {
                recording.isPlaying.toggle()
                recording.isPlaying ? audioPlayerManager.startPlaying(url: recording.fileURL) : audioPlayerManager.stopPlaying()
            }, label: {
                Image(systemName: recording.isPlaying ? "pause.fill" : "play.fill")
                    .foregroundStyle(.red)
                    .font(.system(size: 26))
                
            }).padding(.trailing, 20)
            Text(recording.name)
                .font(.system(size: 16))
        }
    }
}

#Preview {
    RecordingLabelView(recording: Recording(fileURL: URL(fileURLWithPath: "Documents/prova 123"), dateOfRecording: Date.now))
}
