//
//  RecordingLabelView.swift
//  SimpleAudioRecorder
//
//  Created by Alberto Bruno on 24/01/24.
//

import SwiftUI

struct RecordingLabelView: View {
    var recording: Recording
    var myLogger: MyLogger = MyLogger.shared
    var audioPlayerManager: AudioPlayerManager = AudioPlayerManager.shared
    var deleteAction: () -> Void = {}
    @State private var showTranscription: Bool = false
    @State private var audioTranscription = "Lorem Iakshkjhcvbdjhsavckjdshvasj<zhv adjksv dsjashj dajbsdhjasbjdashbjahs"
    
    var body: some View {
        HStack {
            Spacer()
            VStack {
                Text(recording.name)
                    .font(.system(size: 16))
                HStack(spacing: 20) {
                    playButton
                        .padding(.bottom, 25)
                        .padding(.trailing, 10)
                    RecordingSlider(recording)
                    speechTranscriptionButton
                        .padding(.bottom, 25)
                }
                if showTranscription {
                    Text(audioTranscription)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                }
            }.padding(.vertical, 15)
            Spacer()
        }.contextMenu {
            if let url = recording.fileURL {
                ShareLink(item: url) {
                    Label("Share", systemImage: "square.and.arrow.up")
                }
            }
            
            Button(role: .destructive, action: {
                deleteAction()
            }) {
                Label("Delete", systemImage: "trash")
            }
        }
        .background(RoundedRectangle(cornerRadius: 20)
            .foregroundStyle(.recordingLabelBackground))
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
