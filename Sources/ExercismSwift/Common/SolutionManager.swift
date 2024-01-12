//
// Created by Kirk Agbenyegah on 26/09/2022.
//

import Foundation

public class SolutionManager {
    let solution: SolutionFile
    let client: NetworkClient
    let fileManager: FileManager

    public init(with solution: SolutionFile, client: NetworkClient) {
        self.solution = solution
        self.client = client
        fileManager = FileManager.default
    }

    func getOrCreateSolutionDir() throws -> URL {
        do {
            let docsFolder = try fileManager.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true)

            let solutionDir = docsFolder.appendingPathComponent("\(solution.exercise.trackId)/\(solution.exercise.id)/", isDirectory: true)

            if !fileManager.fileExists(atPath: solutionDir.relativePath) {
                try fileManager.createDirectory(atPath: solutionDir.path, withIntermediateDirectories: true)
            }
            return solutionDir
        }
    }

    func downloadFile(at path: String, to destination: URL, completed: @escaping  (Result<URL, ExercismClientError>) -> Void) {
        let url = URL(string: path, relativeTo: URL(string: solution.fileDownloadBaseUrl))!
        client.download(from: url, to: destination, headers: [:]) { result in
            completed(result)
        }
    }

    public func download(_ completed: @escaping(URL?, ExercismClientError?) -> Void) {
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
                    destPath = solutionDir.appendingPathComponent(fileComponents.joined(separator: "/"), isDirectory: true)
                    try fileManager.createDirectory(atPath: destPath.path, withIntermediateDirectories: true)
                }
                downloadFile(at: file,
                             to: destPath.appendingPathComponent(fileName)) { complete in
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
}

extension DispatchQueue {
    static func log(action: String) {
        print("""
            \(action):
            \(String(validatingUTF8: __dispatch_queue_get_label(nil))!)
            \(Thread.current)
            """
        )
    }
}
