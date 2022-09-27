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


    func getOrCreateSolutionDir() -> URL? {
        do {
            let docsFolder = try fileManager.url(
                    for: .documentDirectory,
                    in: .userDomainMask,
                    appropriateFor: nil,
                    create: true)

            let solutionDir = docsFolder.appendingPathComponent("\(solution.exercise.trackId)/\(solution.exercise.id)/", isDirectory: true)

            if !fileManager.fileExists(atPath: solutionDir.relativePath) {
                do {
                    try fileManager.createDirectory(atPath: solutionDir.path, withIntermediateDirectories: true)
                } catch {
                    print("Error creating solution directory: \(error.localizedDescription)")
                    return nil
                }
            }

            return solutionDir
        } catch {
            print("URL error: \(error.localizedDescription)")
            return nil
        }
    }

    func downloadFile(at path: String, to destination: URL) {
        let url = URL(string: path, relativeTo: URL(string: solution.fileDownloadBaseUrl))!
        client.download(from: url, to: destination, headers: [:]) { result in
            switch result {
            case .success(let url):
                print("\(path) - \(url)")
            case .failure(let error):
                print("Error downloading file: \(error)")
            }
        }

    }

    public func download() {
        if let solutionDir = getOrCreateSolutionDir() {
            for file in solution.files {
                do {
                    var fileComponents = file.split(separator: "/")
                    let fileLen = fileComponents.count
                    var destPath = solutionDir
                    let fileName = fileComponents.last!.description
                    if fileLen > 1 {
                        fileComponents.removeLast()
                        destPath = solutionDir.appendingPathComponent(fileComponents.joined(separator: "/"), isDirectory: true)
                        try fileManager.createDirectory(atPath: destPath.path, withIntermediateDirectories: true)
                    }
                    downloadFile(at: file, to: destPath.appendingPathComponent(fileName))
                } catch {
                    print("Error creating solution file (\(file)): \(error.localizedDescription)")
                }
            }
        }
    }
}
