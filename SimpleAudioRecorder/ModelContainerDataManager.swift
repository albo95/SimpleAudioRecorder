//
//  ModelContainerDataManager.swift
//  SimpleAudioRecorder
//
//  Created by Alberto Bruno on 24/01/24.
//

import Foundation
import SwiftData

//final class ModelContainerDataManager {
//    private let modelContainer: ModelContainer
//    private let modelContext: ModelContext
//
//    @MainActor
//    static let shared = ModelContainerDataManager()
//    
//    @MainActor
//    private init() {
//        let schema = Schema([Recording.self])
//        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
//        do {
//            self.modelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])
//            self.modelContext = modelContainer.mainContext
//        } catch {
//            fatalError("Could not create ModelContainer: \(error)")
//        }
//    }
//    
//    func appendNote(_ note: Recording) {
//        modelContext.insert(note)
//        do {
//            try modelContext.save()
//        } catch {
//            fatalError(error.localizedDescription)
//        }
//    }
//    
//    func fetchNotes() -> [Recording] {
//        let fetchDescriptorDateSort = FetchDescriptor<Recording>(sortBy: [SortDescriptor(\.date)])
//
//        do {
//            return try modelContext.fetch(fetchDescriptorDateSort)
//        } catch {
//            fatalError(error.localizedDescription)
//        }
//    }
//    
//    func removeNote(_ note: Recording) {
//        modelContext.delete(note)
//    }
//}
