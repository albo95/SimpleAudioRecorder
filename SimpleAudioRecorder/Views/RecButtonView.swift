//
//  RecButtonView.swift
//  SimpleAudioRecorder
//
//  Created by Alberto Bruno on 24/01/24.
//

import SwiftUI

struct RecButtonView: View {
    @Binding var isRecording: Bool
    @Binding var isEnabed: Bool
    var action: () -> Void
    
    var body: some View {
        VStack {
            Button(action: {
                action()
                isRecording.toggle()
            }, label: {
                Image(systemName: isRecording ? "stop.fill" : "circle.fill")
                    .font(.system(size: 80))
                    .padding(.vertical, isRecording ? 12 : 0)
            })
            .disabled(!isEnabed)
            Text(isRecording ? "Stop" : "Start Recording")
                .padding(.top, 1)
        }
        
        .foregroundStyle(.red)
    }
}

#Preview {
    RecButtonView(isRecording: .constant(true), isEnabed: .constant(true), action: {})
}
