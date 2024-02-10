//
//  iCloudDataManager.swift
//  SimpleAudioRecorder
//
//  Created by Alberto Bruno on 07/02/24.
//

import Foundation
import CloudKit

class CloudDataManager {
    static let shared: CloudDataManager = CloudDataManager()
    private init() {}
    
    func saveRecordToCloud(_ audioRecord: Recording) {
        if let audioRecordName = audioRecord.name, let audioRecordFileUrl = audioRecord.fileURL {
            let ckRecord = CKRecord(recordType: "vocalRecord")
            ckRecord["title"] = "\(audioRecordName)" as NSString
            //TODO: qui lascio i commenti solo per fa capire che puoi mettere tags in questo
            //record["genre"] = genre as CKRecordValue
            //record["comments"] = comments as CKRecordValue
            
            let ckRecordAsset = CKAsset(fileURL: audioRecordFileUrl)
            ckRecord["audio"] = ckRecordAsset
            
            CKContainer.default().publicCloudDatabase.save(ckRecord) { record, error in
                DispatchQueue.main.async {
                    if let error = error {
                        print("Error on uploading to iCloud: \(error.localizedDescription) ")
                        //self.status.text = "Error: \(error.localizedDescription)"
                        //self.spinner.stopAnimating()
                    } else {
                        //self.status.text = "Done!"
                        //self.spinner.stopAnimating()
                        print("Uploaded on iCloud!")
                    }
                }
            }
        }
    }
    
    func loadRecords() -> [Recording]? {
        let pred = NSPredicate(value: true)
        let sort = NSSortDescriptor(key: "creationDate", ascending: false)
        let query = CKQuery(recordType: "vocalRecord", predicate: pred)
        query.sortDescriptors = [sort]
        
        let operation = CKQueryOperation(query: query)
        operation.desiredKeys = ["title", "audio"]
        operation.resultsLimit = 50
        
        var records = [Recording]()
        
        operation.recordMatchedBlock = { recordID, recordResult in
            switch recordResult {
            case .success(let ckRecord):
                let record = Recording.emptyRecording
                record.name = ckRecord["name"]
                records.append(record)
            case .failure(_):
                //TODO: aggiungere gestione fallimento
                print("load record fallita")
            }
            
        }
        
//        operation.queryResultBlock = { [unowned self] (result) in
//            DispatchQueue.main.async {
//                if result. == nil {
//                    //self.tableView.reloadData()
//                } else {
//                    
//                }
//            }
//        }
        CKContainer.default().publicCloudDatabase.add(operation)
        return records
    }
    
    
}
