//
//  AudioRecorderHelper.swift
//  SimpleAudioRecorder
//
//  Created by Alberto Bruno on 26/01/24.
//

import Foundation
import AVFoundation

class AudioRecorderHelper {
    private var logger: MyLogger = MyLogger.shared
    
    func getNewRecordingFileURL(recordingNumber: Int, recordingDate: Date) -> URL {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileName = "Record \(recordingNumber) - \(recordingDate.formattedString()).m4a"
        let fileURL = path.appendingPathComponent(fileName)
        logger.addLog(fileURL.absoluteString)
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
            logger.addLog(MyLog(log: "An error occurred when trying to get the file creation date: \(error.localizedDescription)", type: .error))
            return nil
        }
    }
    
    func getRecordingDuration(url: URL) -> TimeInterval {
        let asset = AVURLAsset(url: url)
        let durationInSeconds = CMTimeGetSeconds(asset.duration)
        return durationInSeconds
    }
}

