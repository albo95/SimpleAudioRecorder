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
    var transcriptionManager: TranscriptionManager = TranscriptionManager.shared
    var deleteAction: () -> Void = {}
    @State private var showTranscription: Bool = false
    @State private var audioTranscription = ""
    @State private var transcriptionText: String? = nil
    @State private var isLoadingTranscription = false
    
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
                    transcriptionView
                        .onAppear {
                            loadTranscription()
                        }
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
        .background(RoundedRectangle(cornerRadius: 15)
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
            withAnimation(.linear(duration: 0.2)) {
                showTranscription.toggle()
            }
        }) {
            Image(systemName: showTranscription ? "text.bubble.fill" : "text.bubble")
                .font(.system(size: 26))
                .foregroundStyle(.red)
                .contentTransition(.symbolEffect(.automatic))
        }
    }
    
    func loadTranscription() {
        isLoadingTranscription = true
        Task {
            await transcriptionTask()
            isLoadingTranscription = false
        }
    }
    
    private var transcriptionView: some View {
        Group {
            if isLoadingTranscription {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
            } else if let transcriptionText = transcriptionText {
                Text(transcriptionText)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 15)
            } else {
                Text("Impossible to load the audio transcription")
                    .padding(.horizontal, 20)
                    .padding(.vertical, 15)
                    .multilineTextAlignment(.center)
            }
        }
    }
    
    private func pausePlaying() {
        audioPlayerManager.pausePlaying()
    }
    
    private func transcriptionTask() async {
        do {
            transcriptionText = try await transcriptionManager.transcribeRecording(recording: recording)
        } catch TranscriptionManager.TranscriptionError.serverError(let statusCode) {
            print("Server error with status code: \(statusCode)")
        } catch TranscriptionManager.TranscriptionError.networkError(let error) {
            print("Network error: \(error.localizedDescription)")
        } catch {
            print("An unexpected error occurred: \(error.localizedDescription)")
        }
    }
}

#Preview {
    RecordingLabelView(recording: Recording.emptyRecording)
}


