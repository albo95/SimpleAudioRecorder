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
    var audioRecorderManager: AudioRecorderManager = AudioRecorderManager.shared
    @State private var hasMicrophoneAccess = false
    @State private var isPlaying: [Bool] = []
    private var logger: MyLogger = MyLogger.shared
    
    var body: some View {
        NavigationStack {
            VStack {
                if hasMicrophoneAccess {
                    List{
                        ForEach(recordings, id: \.dateOfRecording) {
                            recording in
                            RecordingLabelView(recording: recording)
                        }
                        .onDelete(perform: deleteRecording)
                    }.padding(.vertical, 10)
                } else {
                    Text("Allow the access to your microphone to use the app.").multilineTextAlignment(.center)
                        .frame(width: 250)
                        .foregroundStyle(.gray)
                        .font(.system(size: 22))
                }
                VStack {
                    Spacer()
                    RecButtonView(isRecording: $isRecording, isEnabed: $hasMicrophoneAccess, action: {
                        isRecording ? stopRecording() : startRecording()
                    })
                }
            }
            .navigationTitle("Recordings")
        }.onAppear {
            audioRecorderManager.checkMicrophonePermission{ granted in
                hasMicrophoneAccess = granted
            }
        }
    }
    
    func deleteRecording(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(recordings[index])
            try! modelContext.save()
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

