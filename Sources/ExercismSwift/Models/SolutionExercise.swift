//
// Created by Kirk Agbenyegah on 04/07/2022.
//

import Foundation

public struct SolutionExercise: Sendable, Decodable {
    public let id: String
    public let instructionsUrl: String
    public let track: SolutionTrack
    public var trackLanguage: String {
        return track.language
    }

    public var trackId: String {
        return track.id
    }
}

public struct SolutionTrack: Decodable {
    public let id: String
    public let language: String
}
