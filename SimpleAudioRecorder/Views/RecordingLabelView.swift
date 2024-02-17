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
        VStack {
            Text(recording.name)
                .font(.system(size: 16))
            HStack {
                Button(action: {
                    recording.isPlaying.toggle()
                    recording.isPlaying ? audioPlayerManager.play(recording) : pausePlaying()
                }, label: {
                    Image(systemName: recording.isPlaying ? "pause.fill" : "play.fill")
                        .foregroundStyle(.red)
                        .font(.system(size: 26))
                    
                }).padding(.trailing, 20)
                RecordingSlider(recording)
            }
        }
    }
    
    private func pausePlaying() {
        audioPlayerManager.pausePlaying()
    }
}

#Preview {
    RecordingLabelView(recording: Recording.emptyRecording)
}
