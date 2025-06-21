//
// Created by Kirk Agbenyegah on 29/09/2022.
//

import Foundation


/// A representation of an Exercism exercise document, containing solution files, test files, and related metadata.
public struct ExerciseDocument: Sendable {
    /// The root directory of the exercise.
    public var directory: URL

    /// A list of URLs pointing to the solution files within the exercise directory.
    public var solutions: [URL] = []

    /// A list of URLs pointing to the test files within the exercise directory.
    public var tests: [URL] = []

    /// The URL pointing to the exercise's README file, which contains instructions.
    public var instructions: URL? = nil

    /// The solution file associated with the exercise.
    public let solution: SolutionFile

    /// Initializes the exercise document with the provided exercise directory and solution file.
    ///
    /// - Parameters:
    ///   - exerciseDirectory: The directory containing the exercise files.
    ///   - solution: The solution file associated with the exercise.
    /// - Throws: An error if the exercise configuration cannot be loaded or if URLs cannot be created.
    public init(with exerciseDirectory: URL, solution: SolutionFile) throws(ExercismClientError) {
        self.solution = solution
        self.directory = exerciseDirectory

        let configURL = exerciseDirectory.appendingPathComponent(".exercism/config.json")
        let config = try ExerciseDocument.decodeConfig(for: configURL)

        self.solutions = try ExerciseDocument.makeURLs(from: config.files.solution, relativeTo: directory)
        self.tests = try ExerciseDocument.makeURLs(from: config.files.test, relativeTo: directory)
        self.instructions = directory.appendingPathComponent("README.md")
    }

    /// Converts a list of file paths to absolute URLs, relative to a given directory.
    private static func makeURLs(from paths: [String], relativeTo directory: URL) throws(ExercismClientError) -> [URL] {
        var urls: [URL] = []

        for path in paths {
            guard let url = URL(string: path, relativeTo: directory) else {
                throw ExercismClientError.builderError(message: "Failed to create URL for path: \(path)")
            }
            urls.append(url)
        }

        return urls
    }

    /// Decodes the exercise configuration from a JSON file located at the provided URL.
    /// When a solution file is fetched, it contains a `.exercism/config.json` directory with the exercise configuration
    static private func decodeConfig(for url: URL) throws(ExercismClientError) -> ExerciseConfig {
        guard let data = try? Data(contentsOf: url) else {
            throw ExercismClientError.builderError(message: "Failed to load configuration file at \(url)")
        }
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        guard let config = try? decoder.decode(ExerciseConfig.self, from: data) else {
            throw ExercismClientError.builderError(message: "Failed to decode configuration file at \(url)")
        }
        return config
    }
}
