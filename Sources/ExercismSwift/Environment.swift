import Foundation

typealias DebugEnvironment = ExercismSwiftEnvironment

struct ExercismSwiftEnvironment {
    static var log = Logger(handler: PrintLogHandler(), level: .debug)
    static var logHandler: LoggerHandler {
        get { log.handler }
        set { log.handler = newValue }
    }
    
    static var logLevel: LogLevel {
        get { log.level }
        set { log.level = newValue }
    }
}
