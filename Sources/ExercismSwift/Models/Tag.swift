//
// Created by Kirk Agbenyegah on 04/07/2022.
//

import Foundation

public struct Tag: Decodable {
    public var type: String
    public var tags: [String]
}

extension Tag {
    static public func loadTags() -> [Tag] {
        if let bundledUrl = Bundle.main.url(forResource: "Tags", withExtension: "json") {
            if let data = FileManager.default.contents(atPath: bundledUrl.path) {
                do {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601
                    return try decoder.decode([Tag].self, from: data)
                } catch {
                    print(error)
                    return []
                }
            }
            return []
        }
        return []
    }
}
