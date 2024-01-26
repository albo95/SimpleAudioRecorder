//
//  RecordingsViewModel.swift
//  SimpleAudioRecorder
//
//  Created by Alberto Bruno on 23/01/24.
//

import Foundation
import AVFoundation

@Observable
class AudioRecorderManager: NSObject, AVAudioPlayerDelegate {
    public static var shared: AudioRecorderManager = AudioRecorderManager()
    override private init() {}
    
    private let audioSession: AVAudioSession = AVAudioSession.sharedInstance()
    private var audioRecorder : AVAudioRecorder?
    var audioPlayer : AVAudioPlayer?
    var recordingsList: [Recording] = []
    private var newRecording: Recording?
    private var pauseTime: CGFloat = 0
    var currentlyPlayingRecording: Recording?
    var currentPlayingTime: TimeInterval {
        audioPlayer?.currentTime ?? 0
    }
    var currentPlayingRecordDuration: TimeInterval {
        currentlyPlayingRecording?.duration ?? 0
    }
    
    func setUp() {
        fetchAllRecordings()
        resetRecordings()
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag, currentlyPlayingRecording?.isPlaying == true {
            stopPlaying()
        }
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        stopPlaying()
    }

    func startOrResume(url : URL, time: Double? = nil) {
        if currentlyPlayingRecording?.pausedTime != nil {
            resumePlaying()
        } else {
            startPlaying(url: url, time: time)
        }
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
        resetRecordings()
        currentlyPlayingRecording = recordingsList.first(where: { $0.fileURL == url })
        currentlyPlayingRecording?.isPlaying = true
        
        if let time {
            audioPlayer?.play(atTime: time)
        } else {
            audioPlayer?.play()
        }
    }
    
    func resumePlayingAtTime(_ time: TimeInterval) {
        if currentlyPlayingRecording != nil {
            audioPlayer?.currentTime = time
            audioPlayer?.play()
            currentlyPlayingRecording?.isPlaying = true
        }
    }
    
    func pausePlaying() {
        audioPlayer?.pause()
        currentlyPlayingRecording?.pausedTime = audioPlayer?.currentTime
        currentlyPlayingRecording?.isPlaying = false
    }
    
    func resumePlaying(){
        if let audioPlayer = self.audioPlayer, currentlyPlayingRecording?.pausedTime != nil {
            audioPlayer.play()
            currentlyPlayingRecording?.pausedTime = nil
        }
    }
    
    func stopPlaying(){
        resetRecordings()
        currentlyPlayingRecording = nil
        audioPlayer?.stop()
    }
    
    func resetRecordings() {
        recordingsList.forEach({$0.reset()})
    }
    
    func fetchAllRecordings() {
        defer {
            sortRecordingListByDate()
        }
        
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let directoryContents = try! FileManager.default.contentsOfDirectory(at: path, includingPropertiesForKeys: nil)
        
        for fileURL in directoryContents {
            if let fileCreationDate = getCreationDate(fileURL) {
                recordingsList.append(Recording(fileURL: fileURL, dateOfRecording: fileCreationDate, duration: getRecordingDuration(url: fileURL)))
            }
        }
    }
    
    private func getRecordingDuration(url: URL) -> TimeInterval {
        let asset = AVURLAsset(url: url)
        let durationInSeconds = CMTimeGetSeconds(asset.duration)
        return durationInSeconds

    }
    
    func startRecording() {
        do {
            try setUpAudioSession()
        } catch {
            print("Can not setup the Audio Aession")
        }
        
        do {
            audioRecorder = try AVAudioRecorder(
                url: getFileURL(),
                settings: getAudioRecorderSettings()
            )
            audioRecorder?.prepareToRecord()
            audioRecorder?.record()
        } catch {
            newRecording = nil
            print("Can not setup the Audio Recorder")
        }
    }
    
    func setCurrentTime(_ time: TimeInterval) {
        guard currentlyPlayingRecording != nil else { return }
        audioPlayer?.currentTime = time
    }
    
    func stopRecording() {
        if let newRecording = self.newRecording, let duration =  audioRecorder?.currentTime {
            newRecording.duration = duration
            audioRecorder?.stop()
            addToRecordings(newRecording)
            self.newRecording = nil
        }
        resetRecordings()
    }
    
    private func addToRecordings(_ newRecording: Recording) {
        recordingsList.append(Recording(fileURL: newRecording.fileURL, dateOfRecording: newRecording.dateOfRecording))
        sortRecordingListByDate()
    }
    
    private func sortRecordingListByDate() {
        recordingsList.sort(by: { $0.dateOfRecording.compare($1.dateOfRecording) == .orderedDescending})
    }
    
    private func setUpAudioSession() throws {
        try audioSession.setCategory(.playAndRecord, mode: .default)
        try audioSession.setActive(true)
    }
    
    private func getFileURL() -> URL {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let dateOfRecording = Date.now
        let fileName = "\(Int(recordingsList.count)) - \(dateOfRecording.formattedString())"
        let fileURL = path.appendingPathComponent("record \(fileName).m4a")
        self.newRecording = Recording(fileURL: fileURL, dateOfRecording: dateOfRecording)
        return fileURL
    }
    
    private func getAudioRecorderSettings() -> [String: Any] {
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        return settings
    }
    
    private func getCreationDate(_ fileURL: URL) -> Date? {
        let fileManager = FileManager.default
        do {
            let attributes = try fileManager.attributesOfItem(atPath: fileURL.path)
            return attributes[.creationDate] as? Date
        } catch {
            print("An error occurred when trying to get the file creation date: \(error.localizedDescription)")
            return nil
        }
    }
    
    public func checkMicrophonePermission(completion: @escaping (Bool) -> Void) {
        switch AVAudioApplication.shared.recordPermission {
        case .granted:
            completion(true)
        case .denied:
            completion(false)
        case .undetermined:
            AVAudioApplication.requestRecordPermission { granted in
                DispatchQueue.main.async {
                    completion(granted)
                }
            }
        @unknown default:
            completion(false)
        }
    }
}
