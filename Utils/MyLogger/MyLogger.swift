//
//  Logger.swift
//  SimpleAudioRecorder
//
//  Created by Alberto Bruno on 10/02/24.
//

import Foundation
import SwiftUI

@Observable
class MyLogger {
    static let shared: MyLogger = MyLogger()
    private init() {}
    var logs: [MyLog?] = [nil, nil, nil, nil]
    var firstLog: MyLog?
    var secondLog: MyLog?
    var thirdLog: MyLog?
    var fourthLog: MyLog?
    
    func addLog(_ log: String, _ logType: LogType = .none) {
        addLog(MyLog(log: log, type: logType))
    }
    
    func addLog(_ newLog: MyLog) {
        logs.insert(newLog, at: 0)
        if logs.count > 4 {
            logs.removeLast()
        }
        updateLogs()
        print("\(newLog.log)")
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            self.removeLog(newLog)
        }
    }
    
    func updateLogs() {
        firstLog = logs[0]
        secondLog = logs[1]
        thirdLog = logs[2]
        fourthLog = logs[3]
    }
    
    private func removeLog(_ log: MyLog) {
        if let index = logs.firstIndex(where: {$0 == log}) {
            logs.remove(at: index)
            logs.append(nil)
            updateLogs()
        }
    }
}

enum LogType: Equatable {
    case error, loading, completed, none
    
    var color: Color {
        switch self {
        case .error: return .red
        case .loading: return .yellow
        case .completed: return .green
        case .none: return .white
        }
    }
}

struct MyLog: Equatable {
    private var id: UUID
    var log: String
    var type: LogType
    
    init(log: String, type: LogType = .none) {
        self.id = UUID()
        self.log = log
        self.type = type
    }
}
