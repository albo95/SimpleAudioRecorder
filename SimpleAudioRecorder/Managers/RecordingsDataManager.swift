//
//  RecordingsDataManager.swift
//  SimpleAudioRecorder
//
//  Created by Alberto Bruno on 26/01/24.
//

import Foundation

@Observable
class RecordingsDataManager {
    public static var shared: RecordingsDataManager = RecordingsDataManager()
    private let audioRecorderHelper: AudioRecorderHelper = AudioRecorderHelper()
    var allRecordings: [Recording] = []
    
    
    private init() {
        //TODO: AGGIUNGERE FUNZIONI PER I DATI DA ICLOUD ECC
        fetchRecordngsDataFromFileManager()
        resetRecordings()
        sortRecordingListByDate()
    }

    func addToRecordings(_ newRecording: Recording) {
        allRecordings.append(newRecording)
        sortRecordingListByDate()
    }
    
    private func sortRecordingListByDate() {
        allRecordings.sort(by: { $0.dateOfRecording.compare($1.dateOfRecording) == .orderedDescending})
    }
    
    func resetRecordings() {
        allRecordings.forEach({$0.reset()})
    }
    
    func fetchRecordngsDataFromFileManager() {
        defer {
            sortRecordingListByDate()
        }
        
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let directoryContents = try! FileManager.default.contentsOfDirectory(at: path, includingPropertiesForKeys: nil)
        
        for fileURL in directoryContents {
            if let fileCreationDate = audioRecorderHelper.getCreationDate(fileURL) {
                allRecordings.append(Recording(fileURL: fileURL, dateOfRecording: fileCreationDate, duration: audioRecorderHelper.getRecordingDuration(url: fileURL)))
            }
        }
    }
    
}