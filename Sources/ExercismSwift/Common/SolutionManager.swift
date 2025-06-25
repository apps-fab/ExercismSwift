//
// Created by Kirk Agbenyegah on 26/09/2022.
//

import Foundation

/// A manager responsible for downloading and organizing solution files locally.
final class SolutionManager {
    
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
    init(with solution: SolutionFile,
         client: NetworkClient,
         fileManager: FileManager = .default) {
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
        
        do {
            try await withThrowingTaskGroup(of: Void.self) { group in
                for file in solution.files {
                    group.addTask {
                        let destinationURL = try self.makeDestinationURL(for: file, in: solutionDir)
                        _ = try await self.downloadFile(at: file, to: destinationURL)
                    }
                }
                try await group.waitForAll()
            }
        } catch {
            if let clientError = error as? ExercismClientError {
                throw clientError
            } else {
                throw ExercismClientError.builderError(message: error.localizedDescription)
            }
        }
        
        return solutionDir
    }
    
    /// Resolves the local destination URL for a given relative file path.
    private func makeDestinationURL(for relativePath: String, in baseDirectory: URL) throws(ExercismClientError) -> URL {
        let components = relativePath.split(separator: "/").map(String.init)
        guard let fileName = components.last else {
            throw ExercismClientError.builderError(message: "Invalid file name in path: \(relativePath)")
        }
        
        let subfolderPath = components.dropLast().joined(separator: "/")
        let destinationDir = baseDirectory.appendingPathComponent(subfolderPath, isDirectory: true)
        
        // Create intermediate directories if needed
        if !fileManager.fileExists(atPath: destinationDir.path) {
            do {
                try fileManager.createDirectory(at: destinationDir, withIntermediateDirectories: true)
            } catch {
                throw ExercismClientError.builderError(message: "Could not create directory at \(destinationDir.path): \(error.localizedDescription)")
            }
        }
        
        return destinationDir.appendingPathComponent(fileName)
    }
    
    /// Ensures the solution directory exists or creates it.
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
            throw ExercismClientError.builderError(message: "Failed to create solution directory: \(error.localizedDescription)")
        }
    }
    
    /// Downloads a single file from the solution base URL to the specified destination.
    private func downloadFile(at relativePath: String, to destination: URL) async throws(ExercismClientError) -> URL {
        guard let baseURL = URL(string: solution.fileDownloadBaseUrl),
              let fileURL = URL(string: relativePath, relativeTo: baseURL) else {
            throw ExercismClientError.builderError(message: "Invalid download URL for: \(relativePath)")
        }
        
        return try await client.download(from: fileURL, to: destination, headers: [:])
    }
}
