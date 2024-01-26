//
//  RecordingSlider.swift
//  SimpleAudioRecorder
//
//  Created by Alberto Bruno on 24/01/24.
//

import SwiftUI
import AVFoundation

struct RecordingSlider: View {
    var recordingManager: AudioRecorderManager = AudioRecorderManager.shared
    @State private var percentage: CGFloat = 0
    @State private var cursorPos: CGFloat = 0
    private var width: CGFloat = 280
    private var height: CGFloat = 12
    private var actualPos: CGFloat {
        cursorPos - width/2
    }
    private var hide: CGFloat {
        recordingManager.currentlyPlayingRecording == nil ? 0 : 1
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
                            if recordingManager.audioPlayer?.isPlaying == true {                              audioPlayerWasPausedBeforeMovingCursor = true
                                  recordingManager.pausePlaying()
                            }
                            self.percentage = CGFloat(min(max(0, Float(value.location.x / width * 100)), 100))
                        }.onEnded {_ in
                            let currentTime = recordingManager.currentPlayingRecordDuration * percentage/100
                            print("CURRENTTIME: \(currentTime)\n CURRENT DURATION: \(recordingManager.currentPlayingRecordDuration)")
                            if audioPlayerWasPausedBeforeMovingCursor {
                                recordingManager.resumePlayingAtTime(currentTime)
                            } else {
                                recordingManager.setCurrentTime(currentTime)
                            }
                        }
                    )
                Circle()
                    .frame(height: height*2.5)
                    .foregroundStyle(.red)
                    .offset(x: width * CGFloat(self.percentage / 100) - width/2, y: 0)
                    .allowsHitTesting(false)
            }
            HStack {
                Text("\(recordingManager.currentPlayingTime.toMinutesSeconds())")
                    .padding(.trailing, width/3)
                Text("-\((recordingManager.currentPlayingRecordDuration - recordingManager.currentPlayingTime).toMinutesSeconds())")
                    .padding(.leading, width/3)
            }
        }
        .opacity(hide)
        .onReceive(recordingManager.$currentPlayingTime) { currentTime in
            if let duration = recordingManager.currentlyPlayingRecording?.duration, duration > 0 {
                percentage = (currentTime / duration) * 100
            }
        }

    }
}

#Preview {
    RecordingSlider()
}
