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
    private let audioRecorderHelper: AudioRecorderHelper = AudioRecorderHelper()
    private let recordingsDataManager : RecordingsDataManager = RecordingsDataManager.shared
    private var newRecording: Recording?
    
    private var logger: MyLogger = MyLogger.shared

    func startRecording() {
        do {
            try setUpAudioSession()
        } catch {
            logger.addLog(MyLog(log: "Can not setup the Audio Aession", type: .error))
            print("Can not setup the Audio Aession")
        }
        
        do {
            let date = Date.now
            let url = audioRecorderHelper.getNewRecordingFileURL(recordingNumber: recordingsDataManager.allRecordings.count + 1, recordingDate: date)
            audioRecorder = try AVAudioRecorder(
                url: url,
                settings: audioRecorderHelper.getAudioRecorderSettings()
            )
            audioRecorder?.prepareToRecord()
            audioRecorder?.record()
            newRecording = Recording(fileURL: url, dateOfRecording: date)
        } catch {
            newRecording = nil
            logger.addLog(MyLog(log: "Can not setup the Audio Aession", type: .error))
            print("Can not setup the Audio Recorder")
        }
    }
    
    func stopRecording() {
        if let newRecording = self.newRecording, let duration =  audioRecorder?.currentTime {
            newRecording.duration = duration
            audioRecorder?.stop()
            recordingsDataManager.addToRecordings(newRecording)
            self.newRecording = nil
        } else {
            logger.addLog(MyLog(log: "newRec: \(String(describing: self.newRecording)), duration: \(String(describing: audioRecorder?.currentTime))", type: .completed))
            print("newRec: \(String(describing: self.newRecording)), duration: \(String(describing: audioRecorder?.currentTime))")
        }
    }
    
    private func setUpAudioSession() throws {
        try audioSession.setCategory(.playAndRecord, mode: .default)
        try audioSession.setActive(true)
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
