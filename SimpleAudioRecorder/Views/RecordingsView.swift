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
    var recordingManager: AudioRecorderManager = AudioRecorderManager.shared
    @State private var hasMicrophoneAccess = false
    @State private var isPlaying: [Bool] = []
    
    var body: some View {
        NavigationStack {
            ZStack {
                if hasMicrophoneAccess {
                    VStack(alignment: .leading, spacing: 20){
                        ForEach(recordingManager.recordingsList, id: \.fileURL) {
                            recording in
                            RecordingLabelView(recording: recording)
                        }
                        Spacer()
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
                        isRecording ? recordingManager.stopRecording() : recordingManager.startRecording()
                    })
                    .padding(20)
                }
            }
            .navigationTitle("Recordings")
        }.onAppear {
            recordingManager.checkMicrophonePermission{ granted in
                hasMicrophoneAccess = granted
            }
            recordingManager.setUp()
        }
    }
    
    
    private func addItem() {
//        withAnimation {
//            let newItem = Item(timestamp: Date())
//            modelContext.insert(newItem)
//        }
    }
    
    private func deleteItems(offsets: IndexSet) {
//        withAnimation {
//            for index in offsets {
//                modelContext.delete(items[index])
//            }
//        }
    }
}

#Preview {
    RecordingsView()
        .modelContainer(for: Recording.self, inMemory: true)
}

