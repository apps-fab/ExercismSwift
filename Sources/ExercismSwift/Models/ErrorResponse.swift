import Foundation

public struct ErrorResponse {
    public let status: Int
    public let code: String
    public let message: String
}

extension ErrorResponse: Decodable {}
