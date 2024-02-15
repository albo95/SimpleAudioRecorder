//
//  ContentView.swift
//  SimpleAudioRecorder
//
//  Created by Alberto Bruno on 20/01/24.
//

import SwiftUI
import SwiftData
import AVFoundation

struct RecordingsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var recordings: [Recording]
    @State private var isRecording: Bool = false
    //var recordingsDataManager: RecordingsDataManager = RecordingsDataManager.shared
    var audioRecorderManager: AudioRecorderManager = AudioRecorderManager.shared
    @State private var hasMicrophoneAccess = false
    @State private var isPlaying: [Bool] = []
    
    var body: some View {
        NavigationStack {
            ZStack {
                if hasMicrophoneAccess {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 20){
                            ForEach(recordings, id: \.fileURL) {
                                recording in
                                RecordingLabelView(recording: recording)
                            }
                            Spacer()
                        }
                    }.padding(.top, 20)
                } else {
                    Text("Allow the access to your microphone to use the app.").multilineTextAlignment(.center)
                        .frame(width: 250)
                        .foregroundStyle(.gray)
                        .font(.system(size: 22))
                }
                
                VStack {
                    Spacer()
                    RecordingSlider()
                    RecButtonView(isRecording: $isRecording, isEnabed: $hasMicrophoneAccess, action: {
                        isRecording ? stopRecording() : startRecording()
                    })
                    .padding(20)
                }
            }
            .navigationTitle("Recordings")
        }.onAppear {
            audioRecorderManager.checkMicrophonePermission{ granted in
                hasMicrophoneAccess = granted
            }
        }
    }
    
    private func stopRecording() {
        if let newRecording = audioRecorderManager.stopRecording() {
            saveRecording(newRecording)
        }
    }
    
    private func saveRecording(_ newRecording: Recording) {
        modelContext.insert(newRecording)
        try! modelContext.save()
    }
    
    private func startRecording() {
        audioRecorderManager.startRecording()
    }
}

#Preview {
    RecordingsView()
        .modelContainer(for: Recording.self, inMemory: true)
}

