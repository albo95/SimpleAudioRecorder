//
//  AudioPlayerManager.swift
//  SimpleAudioRecorder
//
//  Created by Alberto Bruno on 26/01/24.
//

import Foundation
import AVFAudio

@Observable
class AudioPlayerManager: NSObject, AVAudioPlayerDelegate {
    public static var shared: AudioPlayerManager = AudioPlayerManager()
    override private init() {}
    private var recordingsDataManager: RecordingsDataManager = RecordingsDataManager.shared
    private var allRecordings: [Recording] = RecordingsDataManager.shared.allRecordings
    private var audioPlayer : AVAudioPlayer?
    private var playTimer: Timer?
    var elapsedTime: TimeInterval = 0
    var isPlaying: Bool {
        if let isPlaying = currentlyPlayingRecording?.isPlaying {
            isPlaying
        } else {
            false
        }
    }
    var isActive: Bool {
        if self.currentlyPlayingRecording != nil {
            true
        } else {
            false
        }
    }
    var currentlyPlayingRecording: Recording?
    
    var currentPlayingRecordDuration: TimeInterval {
        currentlyPlayingRecording?.duration ?? 0
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            stopPlaying()
        }
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        stopPlaying()
    }
    
    func startPlaying(url : URL, time: Double? = nil) {
        let playSession = AVAudioSession.sharedInstance()
        
        do {
            try playSession.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
        } catch {
            print("Playing failed in Device")
        }
        
        audioPlayer = try? AVAudioPlayer(contentsOf : url)
        audioPlayer?.delegate = self
        setCurrentPlayingRecord(recordingUrl: url)
        
        if let time {
            audioPlayer?.play(atTime: time)
        } else {
            audioPlayer?.play()
        }
        startTimer()
    }
    
    func pausePlaying() {
        audioPlayer?.pause()
        currentlyPlayingRecording?.pausedTime = audioPlayer?.currentTime
        currentlyPlayingRecording?.isPlaying = false
        stopTimer()
    }
    
    func resumePlaying(){
        if let audioPlayer = self.audioPlayer, currentlyPlayingRecording?.pausedTime != nil {
            audioPlayer.play()
            currentlyPlayingRecording?.pausedTime = nil
            startTimer()
        }
    }
    
    func resumePlayingAtTime(_ time: TimeInterval) {
        if currentlyPlayingRecording != nil {
            audioPlayer?.currentTime = time
            audioPlayer?.play()
            recordingsDataManager.resetRecordings()
            currentlyPlayingRecording?.isPlaying = true
            startTimer()
        }
    }
    
    func startOrResume(url : URL, time: Double? = nil) {
        if currentlyPlayingRecording?.pausedTime != nil {
            resumePlaying()
        } else {
            startPlaying(url: url, time: time)
        }
        startTimer()
    }
    
    func stopPlaying(){
        unsetCurrentPlayingRecord()
        audioPlayer?.stop()
        stopTimer()
    }
    
    func setCurrentTime(_ time: TimeInterval) {
        guard currentlyPlayingRecording != nil else { return }
        audioPlayer?.currentTime = time
    }
    
    private func startTimer() {
        playTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let strongSelf = self else { return }
            if let currentTime = strongSelf.audioPlayer?.currentTime {
                strongSelf.elapsedTime = currentTime
            }
        }
    }
    
    private func stopTimer() {
        playTimer?.invalidate()
        playTimer = nil
    }
    
    private func setCurrentPlayingRecord(recordingUrl: URL) {
        recordingsDataManager.resetRecordings()
        currentlyPlayingRecording = allRecordings.first(where: { $0.fileURL == recordingUrl })
        currentlyPlayingRecording?.isPlaying = true
    }
    
    private func unsetCurrentPlayingRecord() {
        currentlyPlayingRecording = nil
        recordingsDataManager.resetRecordings()
    }
}
