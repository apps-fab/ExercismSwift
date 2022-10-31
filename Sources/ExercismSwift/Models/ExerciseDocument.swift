//
// Created by Kirk Agbenyegah on 29/09/2022.
//

import Foundation

public struct ExerciseDocument {
    public var directory: URL
    public var solutions: [URL] = []
    public var tests: [URL] = []
    public var instructions: URL? = nil

    public init(exerciseDirectory: URL) {
        directory = exerciseDirectory
        let configDir = exerciseDirectory.appendingPathComponent(".exercism/config.json")
        guard let config = ExerciseDocument.decodeConfig(configDir) else {
            //TODO (Kirk - 29/09/2022) - Handle this error properly
            print("Config not found")
            return
        }
        solutions = config.files.solution.map { s in
            URL(string: s, relativeTo: directory)!
        }
        tests = config.files.test.map { s in
            URL(string: s, relativeTo: directory)!
        }
        instructions = directory.appendingPathComponent("README.md")
    }

    static func decodeConfig(_ url: URL) -> ExerciseConfig? {
        do {
            let data = try Data(contentsOf: url)
            return try? JSONDecoder().decode(ExerciseConfig.self, from: data)
        } catch {
            print(error)
            return nil
        }
    }
}
