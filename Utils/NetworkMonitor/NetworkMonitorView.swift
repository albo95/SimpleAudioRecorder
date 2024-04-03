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
            Text("Device not connected to internet.\n\nConnect to keep the iCloud synchronization and translate the recordings.")
                .font(.system(size: 16))
                .multilineTextAlignment(.center)
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.ultraThinMaterial)
                }
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .opacity(opacity)
                .padding(15)
            Spacer()
        }
    }
}

#Preview {
    NetworkMonitorView()
}
