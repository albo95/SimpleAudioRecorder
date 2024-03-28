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
                ZStack {
                    Circle()
                        .foregroundStyle(.red)
                        .frame(height: 70)
                    Image(systemName: isRecording ? "stop.fill" : "mic.fill")
                        .font(.system(size: 30))
                        .foregroundStyle(.white)
                        .contentTransition(.symbolEffect(.replace))
                }
            })
            Text(isRecording ? "Stop" : "Rec")
                .padding(.top, 5)
                .foregroundStyle(.red)
                .font(.system(size: 16))
        }
    }
}

#Preview {
    RecButtonView(isRecording: .constant(true), isEnabed: .constant(true), action: {})
}
