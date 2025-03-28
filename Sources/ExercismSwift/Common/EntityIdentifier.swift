import Foundation

typealias UUIDv4 = String

struct EntityIdentifier<Marker, T: Codable>: CustomStringConvertible {
    let rawValue: T

    init(_ rawValue: T) {
        self.rawValue = rawValue
    }

    var description: String {
        "ID<\(Marker.self)>:\(rawValue)"
    }
}

extension EntityIdentifier: Equatable where T: Equatable {
    static func == (lhs: EntityIdentifier<Marker, T>,
                           rhs: EntityIdentifier<Marker, T>) -> Bool {
        lhs.rawValue == rhs.rawValue
    }
}

extension EntityIdentifier: Hashable where T: Hashable {}

// MARK: - Codable

extension EntityIdentifier: Codable {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        rawValue = try container.decode(T.self)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(rawValue)
    }
}

extension EntityIdentifier where T == UUIDv4 {
    init() {
        self.init(UUIDv4())
    }
}
