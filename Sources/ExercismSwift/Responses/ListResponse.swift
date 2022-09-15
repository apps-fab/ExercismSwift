import Foundation

public struct ListResponse<T> : Decodable where T: Decodable{
    public let results: [T]

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicKey.self)
        self.results = try container.decode([T].self, forKey: container.allKeys.first!)
    }
}

struct DynamicKey: CodingKey {
    var stringValue: String
    init?(stringValue: String) {
        self.stringValue = stringValue
    }

    var intValue: Int?
    init?(intValue: Int) {
        nil
    }

}

//extension ListResponse: Decodable where T: Decodable {
//    enum CodingKeys: String, CodingKey {
//        case results
//    }
//}
