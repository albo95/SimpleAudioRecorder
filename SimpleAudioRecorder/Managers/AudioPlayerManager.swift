//
//  AudioPlayerManager.swift
//  SimpleAudioRecorder
//
//  Created by Alberto Bruno on 26/01/24.
//

import Foundation
import AVFAudio

import Foundation
import AVFAudio

@Observable
final class AudioPlayerManager: NSObject, AVAudioPlayerDelegate {
    static let shared = AudioPlayerManager()
    private override init() {}
    
    private var audioPlayer: AVAudioPlayer?
    private var playTimer: Timer?
    private var myLogger = MyLogger.shared
    private let playSession = AVAudioSession.sharedInstance()
    
    var isPlaying: Bool {
        return audioPlayer?.isPlaying ?? false
    }
    
    var currentlyPlayingRecording: Recording? = nil
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            stopPlaying()
        }
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        stopPlaying()
    }
    
    func play(_ recording: Recording, at time: TimeInterval? = nil) {
        guard recording != currentlyPlayingRecording else {
            resumePlaying(at: time ?? recording.elapsedTime)
            return
        }
        currentlyPlayingRecording?.isPlaying = false
        prepareAndPlay(recording, at: time ?? recording.elapsedTime)
    }
    
    func pausePlaying() {
        stopTimer()
        audioPlayer?.pause()
    }
    
    func stopPlaying() {
        stopTimer()
        audioPlayer?.stop()
        audioPlayer = nil
        currentlyPlayingRecording?.elapsedTime = 0
        currentlyPlayingRecording?.isPlaying = false
        currentlyPlayingRecording = nil
    }
    
    private func prepareAndPlay(_ recording: Recording, at time: TimeInterval? = nil) {
        do {
            let fileURL = try obtainFileURL(for: recording)
            startPlayback(from: fileURL, at: time)
            currentlyPlayingRecording = recording
            currentlyPlayingRecording?.isPlaying = true
        } catch {
            myLogger.addLog(error.localizedDescription)
        }
    }
    
    private func obtainFileURL(for recording: Recording) throws -> URL {
        if let fileURL = recording.fileURL, FileManager.default.fileExists(atPath: fileURL.path) {
            return fileURL
        } else if let data = recording.audioData {
            let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = path.appendingPathComponent(recording.name)
            try data.write(to: fileURL, options: .atomic)
            recording.fileURL = fileURL
            return fileURL
        } else {
            myLogger.addLog("File URL is missing and no in-memory data available.")
            throw NSError(domain: "com.yourapp.AudioPlayerManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "File URL is missing and no in-memory data available."])
        }
    }
    
    private func startPlayback(from url: URL, at time: TimeInterval? = nil) {
        do {
            try playSession.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
        } catch {
            //TODO: capire che fare qui
        }
        
        audioPlayer = try? AVAudioPlayer(contentsOf : url)
        audioPlayer?.delegate = self
        audioPlayer?.prepareToPlay()
        
        if let time, time > 0 {
            audioPlayer?.currentTime = time
        }
        audioPlayer?.play()
        
        startTimer()
    }
    
    private func resumePlaying(at time: TimeInterval? = nil) {
        if let startTime = time, startTime > 0 {
            audioPlayer?.currentTime = startTime
        }
        audioPlayer?.play()
        startTimer()
    }
    
    private func startTimer() {
        playTimer = Timer.scheduledTimer(withTimeInterval: 0, repeats: true) { [weak self] _ in
            self?.updateElapsedTime()
        }
    }
    
    private func updateElapsedTime() {
        currentlyPlayingRecording?.elapsedTime = audioPlayer?.currentTime ?? 0
    }
    
    private func stopTimer() {
        playTimer?.invalidate()
        playTimer = nil
    }
}
