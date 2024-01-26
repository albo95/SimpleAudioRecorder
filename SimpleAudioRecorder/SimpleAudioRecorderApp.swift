//
//  SimpleAudioRecorderApp.swift
//  SimpleAudioRecorder
//
//  Created by Alberto Bruno on 20/01/24.
//

import SwiftUI
import SwiftData

@main
struct SimpleAudioRecorderApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Recording.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            RecordingsView()
        }
        .modelContainer(sharedModelContainer)
    }
}
