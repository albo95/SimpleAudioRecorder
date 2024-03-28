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
    private var audioPlayerManager: AudioPlayerManager
    @State private var showTranscription: Bool = true
    @State private var audioTranscription = "Lorem Iakshkjhcvbdjhsavckjdshvasj<zhv adjksv dsjashj dajbsdhjasbjdashbjahs"
    
    init(recording: Recording) {
        self.recording = recording
        self.audioPlayerManager = AudioPlayerManager.shared
    }
    
    var body: some View {
        VStack {
            HStack {
                playButton
                    .padding(.trailing, 5)
                VStack {
                    Text(recording.name)
                        .font(.system(size: 16))
                    RecordingSlider(recording)
                }
                speechTranscriptionButton
            }
            if showTranscription {
                Text(audioTranscription)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
            }
        }
    }
    
    private var playButton: some View {
        Button(action: {
            recording.isPlaying.toggle()
            recording.isPlaying ? audioPlayerManager.play(recording) : pausePlaying()
        }, label: {
            Image(systemName: recording.isPlaying ? "pause.fill" : "play.fill")
                .foregroundStyle(.red)
                .font(.system(size: 26))
            
        })
    }
    
    private var speechTranscriptionButton: some View {
        Button(action: {
            showTranscription.toggle()
        }) {
            Image(systemName: showTranscription ? "text.bubble.fill" : "text.bubble")
                .font(.system(size: 26))
                .foregroundStyle(.red)
                .contentTransition(.symbolEffect(.automatic))
        }
    }
    
    
    private func pausePlaying() {
        audioPlayerManager.pausePlaying()
    }
}

#Preview {
    RecordingLabelView(recording: Recording.emptyRecording)
}
