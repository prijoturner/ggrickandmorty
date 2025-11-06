//
//  CommonHelper.swift
//  RickNMorty
//
//  Created by Kazuha on 31/10/25.
//

import UIKit

/// A utility class providing common helper functions used throughout the application.
///
/// `CommonHelper` implements the singleton pattern for shared functionality.
class CommonHelper: NSObject {
    
    /// Shared singleton instance of CommonHelper.
    static let shared = CommonHelper()
    private override init() {}
    
    /// Returns the current time formatted as HH:mm:ss.
    ///
    /// - Returns: A string representation of the current time in 24-hour format.
    func currentFormattedTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        return formatter.string(from: Date())
    }
}

/// Defines the severity levels for application logging.
///
/// Log levels determine which messages are printed based on the configured threshold.
public enum AppLogLevel: String {
    /// Debug messages for detailed diagnostic information.
    case debug = "DEBUG"
    /// Informational messages for general application flow.
    case info = "INFO"
    /// Warning messages for potentially harmful situations.
    case warning = "WARNING"
    /// Error messages for error events that might still allow the app to continue.
    case error = "ERROR"
}

/// A flexible logging utility that provides formatted console output with emoji indicators.
///
/// `Logger` supports multiple log levels and can be configured to filter messages
/// based on severity. Each log entry includes a timestamp, file name, line number,
/// and an emoji indicator for quick visual identification.
///
/// ## Usage Example
/// ```swift
/// Logger.shared.debug("Application started")
/// Logger.shared.info("User logged in")
/// Logger.shared.warning("API response slow")
/// Logger.shared.error("Failed to save data")
/// ```
public class Logger {
    
    /// Shared singleton instance of Logger.
    public static let shared = Logger()
    
    /// The current log level threshold. Only messages at this level or higher will be printed.
    public var logLevel: AppLogLevel = .debug
    
    /// Internal method that handles the actual logging logic.
    ///
    /// - Parameters:
    ///   - level: The severity level of the message.
    ///   - message: The message to log.
    ///   - file: The file where the log was called (automatically provided).
    ///   - line: The line number where the log was called (automatically provided).
    private func log(_ level: AppLogLevel, _ message: String, _ file: String, _ line: Int) {
        guard shouldLog(level) else { return }
        let fileName = (file as NSString).lastPathComponent
        let emoji = emojiForLevel(level)
        let currentTime = CommonHelper.shared.currentFormattedTime()
        print("\(emoji) [\(currentTime)] [\(level.rawValue)] [\(fileName):\(line)] - \(message)")
    }
    
    /// Returns an emoji icon for the given log level.
    ///
    /// - Parameter level: The log level to get an emoji for.
    /// - Returns: A string containing the appropriate emoji.
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
    
    /// Determines whether a message at the given level should be logged.
    ///
    /// - Parameter level: The severity level to check.
    /// - Returns: `true` if the message should be logged, `false` otherwise.
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
    
    // MARK: - Public logging functions
    
    /// Logs a debug message.
    ///
    /// Debug messages are only shown when `logLevel` is set to `.debug`.
    ///
    /// - Parameters:
    ///   - message: The message to log.
    ///   - file: The file where the log was called (automatically provided).
    ///   - line: The line number where the log was called (automatically provided).
    public func debug(_ message: String, file: String = #file, line: Int = #line) {
        log(.debug, message, file, line)
    }
    
    /// Logs an informational message.
    ///
    /// Info messages are shown when `logLevel` is `.debug` or `.info`.
    ///
    /// - Parameters:
    ///   - message: The message to log.
    ///   - file: The file where the log was called (automatically provided).
    ///   - line: The line number where the log was called (automatically provided).
    public func info(_ message: String, file: String = #file, line: Int = #line) {
        log(.info, message, file, line)
    }
    
    /// Logs a warning message.
    ///
    /// Warning messages are shown when `logLevel` is `.debug`, `.info`, or `.warning`.
    ///
    /// - Parameters:
    ///   - message: The message to log.
    ///   - file: The file where the log was called (automatically provided).
    ///   - line: The line number where the log was called (automatically provided).
    public func warning(_ message: String, file: String = #file, line: Int = #line) {
        log(.warning, message, file, line)
    }
    
    /// Logs an error message.
    ///
    /// Error messages are always shown regardless of the `logLevel` setting.
    ///
    /// - Parameters:
    ///   - message: The message to log.
    ///   - file: The file where the log was called (automatically provided).
    ///   - line: The line number where the log was called (automatically provided).
    public func error(_ message: String, file: String = #file, line: Int = #line) {
        log(.error, message, file, line)
    }
}
