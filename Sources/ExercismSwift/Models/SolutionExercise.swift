//
// Created by Kirk Agbenyegah on 04/07/2022.
//

import Foundation

public struct SolutionExercise: Sendable {
    public let id: String
    public let instructionsUrl: String
    public let trackId: String
    public let trackLanguage: String

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        instructionsUrl = try container.decode(String.self, forKey: .instructionsUrl)
        let trackContainer = try container.nestedContainer(keyedBy: SolutionExerciseTrackKeys.self, forKey: .track)
        trackId = try trackContainer.decode(String.self, forKey: .id)
        trackLanguage = try trackContainer.decode(String.self, forKey: .language)
    }
}

extension SolutionExercise: Decodable {
    enum CodingKeys: String, CodingKey {
        case id
        case instructionsUrl = "instructions_url"
        case track
    }
}

enum SolutionExerciseTrackKeys: String, CodingKey {
    case id
    case language
}
