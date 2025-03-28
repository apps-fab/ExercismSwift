import Foundation

enum LogLevel: String, CaseIterable {
    case trace
    case debug
    case info
    case notice
    case warning
    case error
}

extension LogLevel {
    internal var naturalIntegralValue: Int {
        switch self {
        case .trace:
            return 0
        case .debug:
            return 1
        case .info:
            return 2
        case .notice:
            return 3
        case .warning:
            return 4
        case .error:
            return 5
        }
    }
}

extension LogLevel: Comparable {
    static func < (lhs: LogLevel, rhs: LogLevel) -> Bool {
        return lhs.naturalIntegralValue < rhs.naturalIntegralValue
    }
}
protocol LoggerHandler: AnyObject {
    func log(level: LogLevel, message: String)
}

final class Logger {
    var handler: LoggerHandler
    var level: LogLevel
    
    init(handler: LoggerHandler, level: LogLevel) {
        self.handler = handler
        self.level = level
    }
    
    func trace(_ message: @autoclosure () -> String) {
        log(level: .trace, message())
    }
    
    func debug(_ message: @autoclosure () -> String) {
        log(level: .debug, message())
    }
    
    func info(_ message: @autoclosure () -> String) {
        log(level: .info, message())
    }
    
    func notice(_ message: @autoclosure () -> String) {
        log(level: .notice, message())
    }
    
    func warning(_ message: @autoclosure () -> String) {
        log(level: .warning, message())
    }
    
    func error(_ message: @autoclosure () -> String) {
        log(level: .error, message())
    }
    
    func log(level: LogLevel,
             _ message: @autoclosure () -> String) {
        if self.level <= level {
            self.handler.log(level: level, message: message())
        }
    }
}

class EmptyLogHandler: LoggerHandler {
    init() {}
    
    func log(level: LogLevel, message: String) {}
}

class PrintLogHandler: LoggerHandler {
    init() {}
    
    func log(level: LogLevel, message: String) {
        print("ExercismSwift \(level.rawValue.uppercased()): \(message)")
    }
}
