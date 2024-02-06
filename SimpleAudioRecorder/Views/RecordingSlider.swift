//
//  RecordingSlider.swift
//  SimpleAudioRecorder
//
//  Created by Alberto Bruno on 24/01/24.
//

import SwiftUI
import AVFoundation

struct RecordingSlider: View {
    var audioPlayerManager: AudioPlayerManager = AudioPlayerManager.shared
    @State private var percentage: CGFloat = 0
    @State private var cursorPos: CGFloat = 0
    private var width: CGFloat = 280
    private var height: CGFloat = 12
    @State private var userJustMovedTheCursor: Bool = false
    private var actualPos: CGFloat {
        cursorPos - width/2
    }
    private var hide: CGFloat {
        audioPlayerManager.isActive ? 1 : 0
    }
    private var elapsedTimeFromPercentage: TimeInterval {
        audioPlayerManager.currentPlayingRecordDuration * percentage/100
    }
    private var timeToEndFromPercentage: TimeInterval {
        audioPlayerManager.currentPlayingRecordDuration * (1 - percentage/100)
    }
    
    
    @State private var audioPlayerWasPausedBeforeMovingCursor: Bool = false
    
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
                            if audioPlayerManager.isPlaying == true {                              audioPlayerWasPausedBeforeMovingCursor = true
                                audioPlayerManager.pausePlaying()
                            }
                            updatePercentageFromGesture(tapLocation: value.location.x)
                        }.onEnded {_ in
                            if audioPlayerWasPausedBeforeMovingCursor {
                                audioPlayerManager.resumePlayingAtTime(elapsedTimeFromPercentage)
                            } else {
                                audioPlayerManager.setCurrentTime(elapsedTimeFromPercentage)
                            }
                            userJustMovedTheCursor = true
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
        .opacity(hide)
        .onChange(of: audioPlayerManager.elapsedTime) { elapsedTime, _ in
            if audioPlayerManager.isPlaying, let duration = audioPlayerManager.currentlyPlayingRecording?.duration, duration > 0 {
                if userJustMovedTheCursor {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        userJustMovedTheCursor = false
                    }
                } else {
                    percentage = (elapsedTime / duration) * 100
                }
            }
        }
    }
    
    private func updatePercentageFromGesture(tapLocation: CGFloat) {
        percentage = CGFloat(min(max(0, Float(tapLocation / width * 100)), 100))
    }
    
    private func getCircleXPos() {
        
    }
}

#Preview {
    RecordingSlider()
}
