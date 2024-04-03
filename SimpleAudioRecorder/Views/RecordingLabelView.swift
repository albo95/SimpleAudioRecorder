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
    @State private var errorMessage: String = ""
    @State private var isLoadingTranscription = false
    
    var body: some View {
        HStack {
            Spacer()
            VStack {
                Text(recording.name)
                    .font(.system(size: 16))
                    .padding(.top, 20)
                HStack(spacing: 20) {
                    playButton
                        .padding(.bottom, 25)
                        .padding(.trailing, 10)
                    RecordingSlider(recording)
                    speechTranscriptionButton
                        .padding(.bottom, 25)
                }.padding(.bottom, 20)
                
                
                if showTranscription {
                    transcriptionView
                        .onAppear {
                            loadTranscription()
                        }
                }
            }
            Spacer()
        }.contextMenu {
            if let url = recording.fileURL {
                ShareLink(item: url) {
                    Label("Share", systemImage: "square.and.arrow.up")
                }
            }
            
            if let transcriptionText = transcriptionText, !transcriptionText.isEmpty {
                Button(action: {
                    UIPasteboard.general.string = transcriptionText
                }) {
                    Label("Copy Text", systemImage: "doc.on.doc")
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
            do {
                if let result = try await transcriptionManager.transcribeRecording(recording) {
                    transcriptionText = result
                }
            } catch TranscriptionManager.TranscriptionError.serverError(let statusCode) {
                errorMessage = "Server error with status code: \(statusCode)\n\nImpossible to load the audio transcription, check the OpenAI APIKey in the settings"
                print(errorMessage)
            } catch TranscriptionManager.TranscriptionError.networkError(let error) {
                errorMessage = "Network error: \(error.localizedDescription)\n\nCheck your internet connection"
                print(errorMessage)
            } catch {
                errorMessage = "An unexpected error occurred: \(error.localizedDescription)\n"
                print(errorMessage)
            }
            isLoadingTranscription = false
        }
    }
    
    private var transcriptionView: some View {
        Group {
            if isLoadingTranscription {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .padding(.bottom, 20)
            } else if let transcriptionText = transcriptionText {
                Text(transcriptionText)
            } else {
                Text("\(errorMessage)\n")
                    .multilineTextAlignment(.center)
            }
        } .padding(.horizontal, 20)
            .padding(.bottom, 10)
    }
    
    private func pausePlaying() {
        audioPlayerManager.pausePlaying()
    }
}

#Preview {
    RecordingLabelView(recording: Recording.emptyRecording)
}


