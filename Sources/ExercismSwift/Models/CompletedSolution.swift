//
// Created by Kirk Agbenyegah on 09/08/2023.
//

import Foundation

public struct CompletedSolution: Decodable, Sendable {
    public let track: Track
    public let exercise: Exercise
    public let unlockedExercises: [Exercise]
    public let unlockedConcepts: [Concept]
    public let conceptProgressions: [ConceptProgressions]

    enum CodingKeys: String, CodingKey {
        case track
        case exercise
        case unlockedExercises = "unlocked_exercises"
        case unlockedConcepts = "unlocked_concepts"
        case conceptProgressions = "concept_progressions"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        track = try container.decode(Track.self, forKey: .track)
        exercise = try container.decode(Exercise.self, forKey: .exercise)
        unlockedExercises = try container.decode([Exercise].self, forKey: .unlockedExercises)
        unlockedConcepts = try container.decode([Concept].self, forKey: .unlockedConcepts)
        conceptProgressions = try container.decode([ConceptProgressions].self, forKey: .conceptProgressions)
    }
}

public struct Concept: Decodable, Sendable {
    public let name: String
}

public struct ConceptProgressions: Decodable, Sendable {
    public let name: String
    public let from: Int
    public let to: Int
    public let total: Int
}
