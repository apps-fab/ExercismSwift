import Foundation

/// A utility class for constructing URLs for the Exercism API.
public class URLBuilder {
    /// The base URL for all network requests.
    let base = Network.exercismBaseURL

    /// Constructs a URL by replacing the `{identifier}` placeholder in the given path with the provided entity identifier.
    ///
    /// - Parameters:
    ///   - path: The `ExercismClientPath` representing the endpoint path.
    ///   - identifier: The entity identifier used to replace `{identifier}` in the path.
    ///   - params: Optional query parameters to be appended to the URL.
    /// - Returns: A fully constructed `URL`.
    /// - Note: This method will terminate execution if the URL cannot be formed.
    public func url<T>(
        for path: ExercismClientPath,
        identifier: EntityIdentifier<T, String>,
        params: [String: String] = [:]) -> URL {
            let newPath = path.rawValue.replacingOccurrences(of: "{identifier}", with: identifier.rawValue)
            guard let url = URL(string: newPath, relativeTo: base) else {
                fatalError("Invalid path, unable to create a URL: \(path)")
            }

            return buildURL(from: url, params: params)
        }

    /// Constructs a URL by formatting the given path with optional arguments and appending query parameters.
    ///
    /// - Parameters:
    ///   - path: The `ExercismClientPath` representing the endpoint path.
    ///   - params: Optional query parameters to be appended to the URL.
    ///   - urlArgs: Variadic arguments used to format the path string.
    /// - Returns: A fully constructed `URL`.
    /// - Note: This method will terminate execution if the URL cannot be formed.
    public func url(for path: ExercismClientPath,
                    params: [String: String] = [:],
                    urlArgs: CVarArg...) -> URL {
        let path = String(format: path.rawValue, arguments: urlArgs)
        guard let url = URL(string: path, relativeTo: base) else {
            fatalError("Invalid path, unable to create a URL: \(path)")
        }

        return buildURL(from: url, params: params)
    }

    /// Appends query parameters to a given URL.
    ///
    /// - Parameters:
    ///   - url: The base `URL` to which query parameters should be added.
    ///   - params: A dictionary of query parameters as key-value pairs.
    /// - Returns: A `URL` with the query parameters appended.
    /// - Note: This method will terminate execution if the URL components cannot be resolved.
    private func buildURL(from url: URL, params: [String: String]) -> URL {
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            fatalError("Invalid URL, unable to build components path")
        }

        if !params.isEmpty {
            components.queryItems = params.map {
                URLQueryItem(name: $0.key, value: $0.value)
            }
        }

        guard let result = components.url else {
            fatalError("Unable to create URL from components (\(components))")
        }

        return result
    }
}

