//
// Created by Kirk Agbenyegah on 29/09/2022.
//

import Foundation

public struct ExerciseDocument: Sendable {
    public var directory: URL
    public var solutions: [URL] = []
    public var tests: [URL] = []
    public var instructions: URL? = nil
    public let solution: SolutionFile

    public init(exerciseDirectory: URL, solution: SolutionFile) throws {
        self.solution = solution
        directory = exerciseDirectory
        let configDir = exerciseDirectory.appendingPathComponent(".exercism/config.json")
        var config: ExerciseConfig?
        config = try ExerciseDocument.decodeConfig(configDir)

        guard let config = config else { return }
        solutions = config.files.solution.map { s in
            URL(string: s, relativeTo: directory)!
        }
        tests = config.files.test.map { s in
            URL(string: s, relativeTo: directory)!
        }
        instructions = directory.appendingPathComponent("README.md")
    }

    static func decodeConfig(_ url: URL) throws -> ExerciseConfig {
        let data = try Data(contentsOf: url)
        let config =  try JSONDecoder().decode(ExerciseConfig.self, from: data)
        return config
    }
}
