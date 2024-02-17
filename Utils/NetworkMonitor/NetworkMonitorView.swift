//
//  NetworkMonitorView.swift
//  SimpleAudioRecorder
//
//  Created by Alberto Bruno on 17/02/24.
//

import SwiftUI

struct NetworkMonitorView: View {
    private var networkMonitor: NetworkMonitor = NetworkMonitor.shared
    private var opacity: CGFloat {
        networkMonitor.isConnected ? 0 : 1
    }
    
    var body: some View {
        VStack {
            Text("Device not connected to internet. Connect to keep the iCloud syncronization.")
                .foregroundStyle(.white)
                .font(.system(size: 20, weight: .semibold))
                .multilineTextAlignment(.leading)
                .padding()
                .background(Color.gray.opacity(0.8))
                .cornerRadius(10)
                .padding(.top, 20)
                .opacity(opacity)
            Spacer()
        }
    }
}

#Preview {
    NetworkMonitorView()
}
