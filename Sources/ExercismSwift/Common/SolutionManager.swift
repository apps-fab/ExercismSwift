//
// Created by Kirk Agbenyegah on 26/09/2022.
//

import Foundation

/// A manager responsible for downloading and organizing solution files locally.
class SolutionManager {

    /// The solution metadata containing file paths and download information.
    let solution: SolutionFile

    /// The network client used to download files.
    let client: NetworkClient

    /// The file manager used to manage local file system operations.
    let fileManager: FileManager

    /// Initializes a new `SolutionManager` instance.
    ///
    /// - Parameters:
    ///   - solution: The `SolutionFile` describing the exercise and associated files.
    ///   - client: The `NetworkClient` used for downloading the files.
    ///   - fileManager: A custom `FileManager` for managing file paths (defaults to `.default`).
    init(
        with solution: SolutionFile,
        client: NetworkClient,
        fileManager: FileManager = .default
    ) {
        self.solution = solution
        self.client = client
        self.fileManager = fileManager
    }

    /// Downloads all solution files and stores them in a local directory.
    ///
    /// - Returns: The URL of the local directory containing the downloaded files.
    /// - Throws: An `ExercismClientError` if the directory creation or download fails.
    func download() async throws(ExercismClientError) -> URL {
        let solutionDir = try getOrCreateSolutionDir()

        for file in solution.files {
            var components = file.split(separator: "/")
            guard let fileName = components.popLast()?.description else {
                throw ExercismClientError.builderError(message: "Invalid file name in path: \(file)")
            }

            var destinationDir = solutionDir
            if !components.isEmpty {
                destinationDir = solutionDir.appendingPathComponent(components.joined(separator: "/"), isDirectory: true)
                do {
                    try fileManager.createDirectory(atPath: destinationDir.path, withIntermediateDirectories: true)
                } catch {
                    throw ExercismClientError.builderError(message: "Failed to create local solution directory: \(error.localizedDescription)")
                }
            }

            let destinationURL = destinationDir.appendingPathComponent(fileName)
            _ = try await downloadFile(at: file, to: destinationURL)
        }

        return solutionDir
    }

    /// Ensures the solution directory exists or creates it.
    ///
    /// - Returns: The URL of the local solution directory.
    /// - Throws: An `ExercismClientError` if directory creation fails.
    private func getOrCreateSolutionDir() throws(ExercismClientError) -> URL {
        do {
            let documents = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)

            let solutionDir = documents
                .appendingPathComponent(solution.exercise.trackId)
                .appendingPathComponent(solution.exercise.id, isDirectory: true)

            if !fileManager.fileExists(atPath: solutionDir.path) {
                try fileManager.createDirectory(at: solutionDir, withIntermediateDirectories: true)
            }

            return solutionDir
        } catch {
            throw ExercismClientError.builderError(message: "Failed to create local solution directory: \(error.localizedDescription)")
        }
    }

    /// Downloads a single file from the provided solution path.
    ///
    /// - Parameters:
    ///   - path: The file path relative to the base URL.
    ///   - destination: The full local file URL to save the file to.
    /// - Returns: The local file URL after download completes.
    /// - Throws: An `ExercismClientError` if the download fails.
    private func downloadFile(at path: String, to destination: URL) async throws(ExercismClientError) -> URL {
        guard let baseURL = URL(string: solution.fileDownloadBaseUrl),
              let fileURL = URL(string: path, relativeTo: baseURL) else {
            throw ExercismClientError.builderError(message: "Invalid download URL for path: \(path)")
        }

        return try await client.download(from: fileURL, to: destination, headers: [:])
    }
}
