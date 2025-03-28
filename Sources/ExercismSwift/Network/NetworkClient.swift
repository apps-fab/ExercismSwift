import Foundation

public enum Network {
    public typealias HTTPHeaders = [String: String]

    public static let exercismBaseURL = URL(string: "https://api.exercism.io/")!

    public enum HTTPMethod: String {
        case GET, POST, PUT, PATCH, DELETE
    }

    public enum Errors: Error {
        case HTTPError(code: Int)
        case genericError(Error)
    }
}

/// A protocol defining a network client for making HTTP requests.
///
/// Conforming types should implement methods for performing common HTTP operations such as GET, POST, PATCH, DELETE, and downloading files.
public protocol NetworkClient: AnyObject {

    /// A dictionary of HTTP headers that will be included in all requests.
    var headers: Network.HTTPHeaders { get }

    /// Performs an HTTP GET request.
    /// - Parameters:
    ///   - url: The URL to send the request to.
    ///   - headers: Optional additional headers to include in the request.
    ///   - completed: A closure returning a `Result` with a decoded response or an error.
    func get<R: Decodable>(from url: URL,
                           headers: Network.HTTPHeaders?,
                           completed: @escaping (Result<R, ExercismClientError>) -> Void )

    /// Performs an HTTP POST request.
    /// - Parameters:
    ///   - url: The URL to send the request to.
    ///   - body: The request body, encoded as JSON.
    ///   - headers: Optional additional headers to include in the request.
    ///   - completed: A closure returning a `Result` with a decoded response or an error.
    func post<T: Encodable, R: Decodable>(to url: URL,
                                          body: T,
                                          headers: Network.HTTPHeaders?,
                                          completed: @escaping (Result<R, ExercismClientError>) -> Void)

    /// Performs an HTTP PATCH request.
    /// - Parameters:
    ///   - url: The URL to send the request to.
    ///   - body: The request body, encoded as JSON.
    ///   - headers: Optional additional headers to include in the request.
    ///   - completed: A closure returning a `Result` with a decoded response or an error.
    func patch<T: Encodable, R: Decodable>(to url: URL,
                                           body: T,
                                           headers: Network.HTTPHeaders?,
                                           completed: @escaping (Result<R, ExercismClientError>) -> Void)

    /// Performs an HTTP DELETE request with a request body.
    /// - Parameters:
    ///   - url: The URL to send the request to.
    ///   - body: The request body, encoded as JSON.
    ///   - headers: Optional additional headers to include in the request.
    ///   - completed: A closure returning a `Result` with a decoded response or an error.
    func delete<T: Encodable, R: Decodable>(from url: URL,
                                            body: T,
                                            headers: Network.HTTPHeaders?,
                                            completed: @escaping (Result<R, ExercismClientError>) -> Void)


    /// Downloads a file from a given URL and saves it to a specified destination.
    /// - Parameters:
    ///   - sourcePath: The URL of the file to download.
    ///   - destPath: The local file URL where the downloaded file should be saved.
    ///   - headers: Optional additional headers to include in the request.
    ///   - completed: A closure returning a `Result` with the local file URL or an error.
    func download(from sourcePath: URL,
                  to destPath: URL,
                  headers: Network.HTTPHeaders?,
                  completed: @escaping (Result<URL, ExercismClientError>) -> Void)
}

/// This is the  default implementation of a network client that handles HTTP requests and responses.
///
/// Supports GET, POST, PATCH, DELETE, and file download operations.
 class DefaultNetworkClient: NetworkClient {
    /// JSON encoder used to encode request bodies.
    private let encoder: JSONEncoder

    /// JSON decoder used to decode responses.
    private let decoder: JSONDecoder

    /// Default HTTP headers included in all requests.
    private let defaultHeaders: Network.HTTPHeaders

    /// User-Agent string sent with all requests.
    ///
    /// A User-Agent is a string that web browsers and HTTP clients send in their requests to identify themselves to the server. It typically includes information about the software making the request, such as its name, version, and operating system. In this case this is the App using the API
    private let userAgent = "Exercism macOS"

    /// Initializes a network client with optional API token authentication.
    /// - Parameter apiToken: An optional API token for authorization.
    init(_ apiToken: String? = nil) {

        encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .formatted(DateFormatter.iso8601Full)

        decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        var headers = [
            "User-Agent": userAgent,
        ]
        if let apiToken = apiToken {
            headers["Authorization"] = "Bearer \(apiToken)"
        }
        defaultHeaders = headers
    }

    /// Returns the default HTTP headers used for requests.
    var headers: Network.HTTPHeaders {
        defaultHeaders
    }

    /// Performs a GET request to the specified URL.
    /// - Parameters:
    ///   - url: The target URL for the request.
    ///   - headers: Optional custom headers for the request.
    ///   - completed: A completion handler returning a `Result` containing the decoded response or an error.
    func get<R: Decodable>(from url: URL,
                                  headers: Network.HTTPHeaders? = nil,
                                  completed: @escaping (Result<R, ExercismClientError>) -> Void) {
        let request = buildRequest(method: .GET, url: url, headers: headers)
        print(request.url?.absoluteURL ?? "")
        executeRequest(request: request, completed: completed)
    }

    /// Performs a POST request with a request body.
    /// - Parameters:
    ///   - url: The target URL for the request.
    ///   - body: The request body to be sent.
    ///   - headers: Optional custom headers.
    ///   - completed: A completion handler returning a `Result` containing the decoded response or an error.
    func post<T: Encodable, R: Decodable>(to url: URL,
                                                 body: T,
                                                 headers: Network.HTTPHeaders? = nil,
                                                 completed: @escaping (Result<R, ExercismClientError>) -> Void) {
        var request = buildRequest(method: .POST, url: url, headers: headers)
        let requestBody: Data

        do {
            requestBody = try encoder.encode(body)
        } catch {
            completed(.failure(.bodyEncodingError(error)))
            return
        }
        DebugEnvironment.log.trace("BODY:\n " + String(data: requestBody, encoding: .utf8)!)
        request.httpBody = requestBody
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        executeRequest(request: request, completed: completed)
    }

    /// Performs a PATCH request with a request body.
    /// - Parameters:
    ///   - url: The target URL for the request.
    ///   - body: The request body to be sent.
    ///   - headers: Optional custom headers.
    ///   - completed: A completion handler returning a `Result` containing the decoded response or an error.
    func patch<T: Encodable, R: Decodable>(to url: URL,
                                                  body: T,
                                                  headers: Network.HTTPHeaders? = nil,
                                                  completed: @escaping (Result<R, ExercismClientError>) -> Void) {
        var request = buildRequest(method: .PATCH, url: url, headers: headers)
        let requestBody: Data

        do {
            requestBody = try encoder.encode(body)
        } catch {
            completed(.failure(.bodyEncodingError(error)))
            return
        }

        DebugEnvironment.log.trace("BODY:\n " + String(data: requestBody, encoding: .utf8)!)

        request.httpBody = requestBody
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        executeRequest(request: request, completed: completed)
    }

    /// Performs a DELETE request with an optional request body.
    /// - Parameters:
    ///   - url: The target URL for the request.
    ///   - body: An optional request body to be sent.
    ///   - headers: Optional custom headers.
    ///   - completed: A completion handler returning a `Result` containing the decoded response or an error.
    func delete<R: Decodable, T: Encodable>(from url: URL,
                                                   body: T,
                                                   headers: Network.HTTPHeaders? = nil,
                                                   completed: @escaping (Result<R, ExercismClientError>) -> Void) {
        var request = buildRequest(method: .DELETE, url: url, headers: headers)
        let requestBody: Data

        do {
            requestBody = try encoder.encode(body)
        } catch {
            completed(.failure(.bodyEncodingError(error)))
            return
        }

        DebugEnvironment.log.trace("BODY:\n " + String(data: requestBody, encoding: .utf8)!)

        request.httpBody = requestBody
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        executeRequest(request: request, completed: completed)
    }

    /// Downloads a file from a specified URL and saves it to the given destination path.
    ///
    /// - If successful, if the file exists locally, it is replaced; otherwise, it is created. The completion handler is updated with the destination path
    /// - Parameters:
    ///   - sourcePath: The URL to download the file from.
    ///   - destPath: The destination URL where the file should be saved.
    ///   - headers: Optional custom headers.
    ///   - completed: A completion handler returning a `Result` containing the file URL or an error.
    func download(from sourcePath: URL,
                         to destPath: URL,
                         headers: Network.HTTPHeaders? = [:],
                         completed: @escaping (Result<URL, ExercismClientError>) -> Void) {
        let request = initRequest(url: sourcePath, headers: headers)

        let task = URLSession.shared.downloadTask(with: request) { tempURL, response, error in
            if let error = NetworkClientHelpers.extractError(response: response, error: error) {
                DispatchQueue.main.async {
                    completed(.failure(error))
                }
                return
            }

            guard let tempURL = tempURL else {
                DispatchQueue.main.async {
                    completed(.failure(.unsupportedResponseError))
                }
                return
            }

            DebugEnvironment.log.trace("Downloaded file location: \(tempURL)")

            do {
                if FileManager.default.fileExists(atPath: destPath.relativePath) {
                    try FileManager.default.removeItem(at: destPath)
                }
                try FileManager.default.moveItem(at: tempURL, to: destPath)
                DispatchQueue.main.async {
                    completed(.success(destPath))
                }
            } catch {
                DispatchQueue.main.async {
                    completed(.failure(.genericError(error)))
                }
            }
        }

        task.resume()
    }

    /// Builds a URL request with the specified HTTP method and headers.
    /// - Parameters:
    ///   - method: A  `HTTPMethod` type
    ///   - url: A `URL` type created from base url and path
    ///   - headers: The headers associated with the request
    /// - Returns: A `URLRequest` type
    private func initRequest(url: URL, headers: Network.HTTPHeaders? = [:]) -> URLRequest {
        let allHeaders = defaultHeaders.merging(headers ?? [:]) { (_, new) in
            new
        }
        var request = URLRequest(url: url)
        for item in allHeaders {
            request.setValue(item.value, forHTTPHeaderField: item.key)
        }

        return request
    }

    /// Builds a URL request with the specified HTTP method and headers.
    /// - Parameters:
    ///   - method: A  `HTTPMethod` type
    ///   - url: A `URL` type created from base url and path
    ///   - headers: The headers associated with the request
    /// - Returns: A `URLRequest` type
    private func buildRequest(method: Network.HTTPMethod,
                              url: URL,
                              headers: Network.HTTPHeaders?) -> URLRequest {
        var request = initRequest(url: url, headers: headers)
        request.httpMethod = method.rawValue

        return request
    }

    /// Executes a network request, processes the response, and decodes it into the specified type.
    ///
    /// - The method sends an HTTP request using `URLSession.shared.dataTask(with:)`.
    /// - It checks for errors using `NetworkClientHelpers.extractError(data:response:error:)` and returns a failure if an error is found.
    /// - If the request succeeds and data is received, it attempts to decode the data into the specified type `T: Decodable`.
    /// - If decoding fails, it captures and returns a `.decodingError` or a `.genericError`.
    /// - The result is returned asynchronously on the main thread via the `completed` closure.
    ///
    /// - Parameters:
    ///   - request: The `URLRequest` to be executed.
    ///   - completed: A completion handler returning a `Result<T, ExercismClientError>`,
    ///     where `T` is the expected response type if decoding succeeds, or an error otherwise.
    private func executeRequest<T: Decodable>(request: URLRequest,
                                              completed: @escaping (Result<T, ExercismClientError>) -> Void) {
        DebugEnvironment.log.debug("Request: \(request.httpMethod ?? "") \(request.url?.absoluteString ?? "")")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            var completeResult: Result<T, ExercismClientError>?

            // Extract error if any exists
            if let error = NetworkClientHelpers.extractError(data: data, response: response, error: error) {
                completeResult = .failure(error)
            }
            // If no error, attempt to decode response data
            else if let data = data {
                DebugEnvironment.log.trace(String(data: data, encoding: .utf8) ?? "")
                do {
                    let result = try self.decoder.decode(T.self, from: data)
                    completeResult = .success(result)
                } catch let decodingError as Swift.DecodingError {
                    completeResult = .failure(.decodingError(decodingError))
                } catch {
                    completeResult = .failure(.genericError(error))
                }
            }
            // If no data and no specific error, return an unsupported response error
            else {
                completeResult = .failure(.unsupportedResponseError)
            }

            // Ensure the completion handler is executed on the main thread
            DispatchQueue.main.async {
                guard let completeResult = completeResult else {
                    fatalError("Unexpected state: No result available!")
                }
                completed(completeResult)
            }
        }

        task.resume()
    }

}
