//
// Created by Kirk Agbenyegah on 26/09/2022.
//

import Foundation

/// A manager responsible for handling solution file downloads and organization.
class SolutionManager {
    /// The `SolutionFile` downloaded from  `downloadSolution`
    let solution: SolutionFile
    
    /// The network client used for downloading files.
    let client: NetworkClient
    
    /// The file manager responsible for handling file operations.
    let fileManager: FileManager
    
    /// Initializes a new `SolutionManager` instance.
    ///
    /// - Parameters:
    ///   - solution: The `SolutionFile` containing file details.
    ///   - client: The `NetworkClient` used for downloading solution files.
    ///   - fileManager: The `FileManager` instance for handling local file operations. Defaults to `FileManager.default`.
    init(with solution: SolutionFile,
         client: NetworkClient,
         fileManager: FileManager = FileManager.default) {
        self.solution = solution
        self.client = client
        self.fileManager = fileManager
    }
    
    /// Downloads all solution files to a local directory.
    ///
    /// - Parameter completed: A closure that returns the local directory URL or an error.
    ///
    /// - Note: This method creates the required directory structure before downloading files.
    func download(_ completed: @escaping (URL?, ExercismClientError?) -> Void) {
        let dispatchGroup = DispatchGroup()
        var error: ExercismClientError?
        
        do {
            let solutionDir = try getOrCreateSolutionDir()
            
            for file in solution.files {
                dispatchGroup.enter()
                var fileComponents = file.split(separator: "/")
                let fileLen = fileComponents.count
                var destPath = solutionDir
                let fileName = fileComponents.last!.description
                
                if fileLen > 1 {
                    fileComponents.removeLast()
                    destPath = solutionDir
                        .appendingPathComponent(fileComponents.joined(separator: "/"), isDirectory: true)
                    try fileManager.createDirectory(atPath: destPath.path,
                                                    withIntermediateDirectories: true)
                }
                
                downloadFile(at: file,
                             to: destPath.appendingPathComponent(fileName)) { _ in
                    dispatchGroup.leave()
                }
            }
            
            dispatchGroup.notify(queue: DispatchQueue.main) {
                if let error = error {
                    completed(nil, error)
                } else {
                    completed(solutionDir, nil)
                }
            }
        } catch let error {
            completed(nil, .builderError(message: error.localizedDescription))
        }
    }
    
    /// Retrieves or creates the local directory for storing solution files.
    ///
    /// - Returns: The URL of the solution directory.
    /// - Throws: An error if the directory cannot be created.
    private func getOrCreateSolutionDir() throws -> URL {
        let docsFolder = try fileManager.url(for: .documentDirectory,
                                             in: .userDomainMask,
                                             appropriateFor: nil,
                                             create: true)
        
        let solutionDir = docsFolder
            .appendingPathComponent("\(solution.exercise.trackId)/\(solution.exercise.id)/", isDirectory: true)
        
        if !fileManager.fileExists(atPath: solutionDir.relativePath) {
            try fileManager.createDirectory(atPath: solutionDir.path, withIntermediateDirectories: true)
        }
        
        return solutionDir
    }
    
    /// Downloads a single file from the solution's file download URL.
    ///
    /// - Parameters:
    ///   - path: The file path to download.
    ///   - destination: The local destination URL for the downloaded file.
    ///   - completed: A closure that returns a result containing the file URL or an error.
    private func downloadFile(at path: String,
                              to destination: URL,
                              completed: @escaping (Result<URL, ExercismClientError>) -> Void) {
        let url = URL(string: path,
                      relativeTo: URL(string: solution.fileDownloadBaseUrl))!
        client.download(from: url,
                        to: destination,
                        headers: [:]) { result in
            completed(result)
        }
    }
}
