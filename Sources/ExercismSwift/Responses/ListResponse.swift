import Foundation

public struct ListResponse<T>: Decodable where T: Decodable {
    public var results: [T] = []
    public var meta: ListMeta? = nil

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicKey.self)
        for key in container.allKeys {
            if key.stringValue == "meta" {
                meta = try container.decodeIfPresent(ListMeta.self, forKey: key)
            } else {
                results = try container.decode([T].self, forKey: key)
            }
        }
    }
}

public struct DynamicKey: CodingKey {
    public var stringValue: String

    public init?(stringValue: String) {
        self.stringValue = stringValue
    }

    public var intValue: Int?

    public init?(intValue: Int) {
        nil
    }
}
