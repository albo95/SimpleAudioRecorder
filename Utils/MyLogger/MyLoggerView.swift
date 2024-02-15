//
//  MyLoggerView.swift
//  SimpleAudioRecorder
//
//  Created by Alberto Bruno on 10/02/24.
//

import SwiftUI

struct MyLoggerView: View {
    private var logger: MyLogger = MyLogger.shared
    private var textSize: CGFloat = 14
    private var showLogger: Bool {
        return !(logger.firstLog == nil && logger.secondLog == nil && logger.thirdLog == nil && logger.fourthLog == nil)
    }
    
    var body: some View {
        VStack {
            VStack {
                if let fourthLog = logger.fourthLog {
                    Text("\(fourthLog.log)")
                        .foregroundStyle(fourthLog.type.color)
                        .font(.system(size: textSize, weight: .semibold))
                        .multilineTextAlignment(.leading)
                        .padding(.vertical, 5)
                }
                if let thirdLog = logger.thirdLog {
                    Text("\(thirdLog.log)")
                        .foregroundStyle(thirdLog.type.color)
                        .font(.system(size: textSize, weight: .semibold))
                        .multilineTextAlignment(.leading)
                        .padding(.vertical, 5)
                }
                if let secondLog = logger.secondLog {
                    Text("\(secondLog.log)")
                        .foregroundStyle(secondLog.type.color)
                        .font(.system(size: textSize, weight: .semibold))
                        .multilineTextAlignment(.leading)
                        .padding(.vertical, 5)
                }
                if let firstLog = logger.firstLog {
                    Text("\(firstLog.log)")
                        .foregroundStyle(firstLog.type.color)
                        .font(.system(size: textSize, weight: .semibold))
                        .multilineTextAlignment(.leading)
                        .padding(.vertical, 5)
                }
            }
            .padding()
            .background(Color.gray.opacity(0.8))
            .cornerRadius(10)
            .padding(.top, 50)
            .opacity(showLogger ? 1 : 0)
            
            Spacer()

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

