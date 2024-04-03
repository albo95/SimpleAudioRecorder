//
//  SettingsView.swift
//  SimpleAudioRecorder
//
//  Created by Alberto Bruno on 03/04/24.
//

import SwiftUI

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    @State private var apiKey: String = UserDefaults.standard.string(forKey: "OpenAI_APIKey") ?? ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("OpenAI API Key")) {
                    TextField("", text: $apiKey)
                        .autocapitalization(.none)
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        UserDefaults.standard.set(apiKey, forKey: "OpenAI_APIKey")
                        dismiss()
                    }
                }
            }
        }
    }
}


#Preview {
    SettingsView()
}
