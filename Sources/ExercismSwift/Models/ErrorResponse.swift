import Foundation

public struct ErrorResponse {
    public let error: ErrorDetail
}

extension ErrorResponse: Decodable {}


