//
//  CommonHelper.swift
//  RickNMorty
//
//  Created by Kazuha on 31/10/25.
//

import UIKit

class CommonHelper: NSObject {
    
    static let shared = CommonHelper()
    private override init() {}
    
    func currentFormattedTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        return formatter.string(from: Date())
    }
}

public enum AppLogLevel: String {
    case debug = "DEBUG"
    case info = "INFO"
    case warning = "WARNING"
    case error = "ERROR"
}

public class Logger {
    
    public static let shared = Logger()
    public var logLevel: AppLogLevel = .debug
    
    // Log message function
    private func log(_ level: AppLogLevel, _ message: String, _ file: String, _ line: Int) {
        guard shouldLog(level) else { return }
        let fileName = (file as NSString).lastPathComponent
        let emoji = emojiForLevel(level)
        let currentTime = CommonHelper.shared.currentFormattedTime()
        print("\(emoji) [\(currentTime)] [\(level.rawValue)] [\(fileName):\(line)] - \(message)")
    }
    
    // Emoji for log level
    private func emojiForLevel(_ level: AppLogLevel) -> String {
        switch level {
        case .debug:
            return "🐛"
        case .info:
            return "ℹ️"
        case .warning:
            return "⚠️"
        case .error:
            return "❌"
        }
    }
    
    // Check if the message should be logged
    private func shouldLog(_ level: AppLogLevel) -> Bool {
        switch level {
        case .debug:
            return logLevel == .debug
        case .info:
            return logLevel == .debug || logLevel == .info
        case .warning:
            return logLevel == .debug || logLevel == .info || logLevel == .warning
        case .error:
            return true
        }
    }
    
    // Public logging functions
    public func debug(_ message: String, file: String = #file, line: Int = #line) {
        log(.debug, message, file, line)
    }
    
    public func info(_ message: String, file: String = #file, line: Int = #line) {
        log(.info, message, file, line)
    }
    
    public func warning(_ message: String, file: String = #file, line: Int = #line) {
        log(.warning, message, file, line)
    }
    
    public func error(_ message: String, file: String = #file, line: Int = #line) {
        log(.error, message, file, line)
    }
}
