//
//  RecordingLabelView.swift
//  SimpleAudioRecorder
//
//  Created by Alberto Bruno on 24/01/24.
//

import SwiftUI

struct RecordingLabelView: View {
    var recording: Recording
    
    var body: some View {
        HStack {
            Button(action: {
                recording.isPlaying.toggle()
                recording.isPlaying ? AudioRecorderManager.shared.startOrResume(url: recording.fileURL, time: recording.pausedTime) : AudioRecorderManager.shared.pausePlaying()
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
