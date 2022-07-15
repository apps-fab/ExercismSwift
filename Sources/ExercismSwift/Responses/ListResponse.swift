import Foundation

public struct ListResponse<T> {
    public let results: [T]

    public init(results: [T], nextCursor: String?, hasMore: Bool) {
        self.results = results
    }
}

extension ListResponse: Decodable where T: Decodable {
    enum CodingKeys: String, CodingKey {
        case results
    }
}
