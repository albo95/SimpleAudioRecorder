//
//  AudioRecorderHelper.swift
//  SimpleAudioRecorder
//
//  Created by Alberto Bruno on 26/01/24.
//

import Foundation
import AVFoundation

class AudioRecorderHelper {
    
    func getNewRecordingFileURL(recordingNumber: Int, recordingDate: Date) -> URL {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileName = "Record \(recordingNumber) - \(recordingDate.formattedString()).m4a"
        let fileURL = path.appendingPathComponent(fileName)
        return fileURL
    }
    
    func getAudioRecorderSettings() -> [String: Any] {
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        return settings
    }
    
    func getCreationDate(_ fileURL: URL) -> Date? {
        let fileManager = FileManager.default
        do {
            let attributes = try fileManager.attributesOfItem(atPath: fileURL.path)
            return attributes[.creationDate] as? Date
        } catch {
            print("An error occurred when trying to get the file creation date: \(error.localizedDescription)")
            return nil
        }
    }
    
    func getRecordingDuration(url: URL) -> TimeInterval {
        let asset = AVURLAsset(url: url)
        let durationInSeconds = CMTimeGetSeconds(asset.duration)
        return durationInSeconds
    }
}

