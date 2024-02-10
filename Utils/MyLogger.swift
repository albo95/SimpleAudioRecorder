//
//  Logger.swift
//  SimpleAudioRecorder
//
//  Created by Alberto Bruno on 10/02/24.
//

import Foundation
import SwiftUI

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
    
    init(log: String, type: LogType) {
        self.id = UUID()
        self.log = log
        self.type = type
    }
}

@Observable
class MyLogger {
    static let shared: MyLogger = MyLogger()
    private init() {}
    var logs: [MyLog?] = [nil, nil, nil, nil]
    var firstLog: MyLog?
    var secondLog: MyLog?
    var thirdLog: MyLog?
    var fourthLog: MyLog?
    
    func addLog(_ newLog: MyLog) {
        logs.insert(newLog, at: 0)
        if logs.count > 4 {
            logs.removeLast()
        }
        updateLogs()
        
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



struct MyLoggerView: View {
    private var myLogger: MyLogger = MyLogger.shared
    private var textSize: CGFloat = 24
    
    var body: some View {
        VStack {
            Spacer()
            VStack {
                if let fourthLog = myLogger.fourthLog {
                    Text("\(fourthLog.log)")
                        .foregroundStyle(fourthLog.type.color)
                        .font(.system(size: textSize, weight: .semibold))
                        .multilineTextAlignment(.leading)
                }
                if let thirdLog = myLogger.thirdLog {
                    Text("\(thirdLog.log)")
                        .foregroundStyle(thirdLog.type.color)
                        .font(.system(size: textSize, weight: .semibold))
                        .multilineTextAlignment(.leading)
                }
                if let secondLog = myLogger.secondLog {
                    Text("\(secondLog.log)")
                        .foregroundStyle(secondLog.type.color)
                        .font(.system(size: textSize, weight: .semibold))
                        .multilineTextAlignment(.leading)
                }
                if let firstLog = myLogger.firstLog {
                    Text("\(firstLog.log)")
                        .foregroundStyle(firstLog.type.color)
                        .font(.system(size: textSize, weight: .semibold))
                        .multilineTextAlignment(.leading)
                }
            }
            .padding()
            .background(Color.black.opacity(0.3))
            .cornerRadius(10)
//        }.onAppear(){
//            for _ in 0..<5 {
//                let randSec = TimeInterval(Int.random(in: 5...10))
//                DispatchQueue.main.asyncAfter(deadline: .now() + randSec) {
//                    let randLog = Int.random(in: 1...3)
//                    if randLog == 1 {
//                        myLogger.addLog(MyLog(log: "Erroreeeee!!!", type: .error))
//                    } else if randLog == 2 {
//                        myLogger.addLog(MyLog(log: "CARICANDO.....", type: .loading))
//                    } else if randLog == 3 {
//                        myLogger.addLog(MyLog(log: "Operazione completata con successo!!!", type: .completed))
//                    }
//                }
//            }
        }
    }
}

#Preview {
    MyLoggerView()
}

