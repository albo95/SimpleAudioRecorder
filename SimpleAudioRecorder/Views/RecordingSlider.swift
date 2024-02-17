//
//  RecordingSlider.swift
//  SimpleAudioRecorder
//
//  Created by Alberto Bruno on 24/01/24.
//

import SwiftUI
import AVFoundation

struct RecordingSlider: View {
    var recording: Recording
    @State private var percentage: CGFloat = 0
    @State private var cursorPos: CGFloat = 0
    @State private var audioPlayerWasPlayingBeforeMovingCursor: Bool = false
    @State private var userJustMovedTheCursor: Bool = false
    private var audioPlayerManager: AudioPlayerManager = AudioPlayerManager.shared
    private var width: CGFloat = 230
    private var height: CGFloat = 8
    private var actualPos: CGFloat {
        cursorPos - width/2
    }
    private var elapsedTimeFromPercentage: TimeInterval {
        recording.duration * percentage/100
    }
    private var timeToEndFromPercentage: TimeInterval {
        recording.duration * (1 - percentage/100)
    }
    private var step: TimeInterval {
        100/recording.duration
    }
    
    init(_ recording: Recording){
        self.recording = recording
    }
    
    var body: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 7)
                    .frame(width: width, height: height)
                    .foregroundStyle(.red)
                    .opacity(0.5)
                    .gesture(DragGesture(minimumDistance: 0)
                        .onChanged {
                            value in
                            if recording.isPlaying == true {
                                audioPlayerWasPlayingBeforeMovingCursor = true
                                audioPlayerManager.pausePlaying()
                            }
                            updatePercentageFromGesture(tapLocation: value.location.x)
                        }.onEnded {_ in
                            if audioPlayerWasPlayingBeforeMovingCursor, recording.isPlaying == true {
                                audioPlayerManager.play(recording, at: elapsedTimeFromPercentage)
                            } else {
                                recording.elapsedTime = elapsedTimeFromPercentage
                            }
                        }
                    )
                Circle()
                    .frame(height: height * 2.5)
                    .foregroundStyle(.red)
                    .offset(x: width * CGFloat(self.percentage / 100) - width/2, y: 0)
                    .allowsHitTesting(false)
            }
            HStack {
                Text("\(elapsedTimeFromPercentage.toMinutesSeconds())")
                    .padding(.trailing, width/3)
                Text("-\(timeToEndFromPercentage.toMinutesSeconds())")
                    .padding(.leading, width/3)
            }
        }
        .onChange(of: recording.elapsedTime) { elapsedTime, _ in
                updateSlider()
        }
    }
    
    private func updateSlider() {
            //                if userJustMovedTheCursor {
            //                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            //                        userJustMovedTheCursor = false
            //                    }
            //                } else {
            percentage = (recording.elapsedTime / recording.duration) * 100
            // }

    }
    
    private func updatePercentageFromGesture(tapLocation: CGFloat) {
        percentage = CGFloat(min(max(0, Float(tapLocation / width * 100)), 100))
    }
    
    private func getCircleXPos() {
        
    }
}

#Preview {
    RecordingSlider(Recording.emptyRecording)
}
