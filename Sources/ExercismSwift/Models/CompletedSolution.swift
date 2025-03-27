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
