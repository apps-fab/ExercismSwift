import Foundation

public enum Network {
    public typealias HTTPHeaders = [String: String]
    
    public static let exercismBaseURL = URL(string: "https://api.exercism.io/")!
    
    public enum HTTPMethod: String {
        case GET, POST, PUT, PATCH, DELETE
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
    /// - Returns: A decoded response of type `R`.
    /// - Throws: An `ExercismClientError` if the request fails or decoding fails.
    func get<R: Decodable>(from url: URL, headers: Network.HTTPHeaders?) async throws(ExercismClientError) -> R

    /// Performs an HTTP POST request.
    /// - Parameters:
    ///   - url: The URL to send the request to.
    ///   - body: The request body, encoded as JSON.
    ///   - headers: Optional additional headers to include in the request.
    /// - Returns: A decoded response of type `R`.
    /// - Throws: An `ExercismClientError` if encoding, network, or decoding fails.
    func post<T: Encodable, R: Decodable>(to url: URL, body: T, headers: Network.HTTPHeaders?) async throws(ExercismClientError) -> R

    /// Performs an HTTP PATCH request.
    /// - Parameters:
    ///   - url: The URL to send the request to.
    ///   - body: The request body, encoded as JSON.
    ///   - headers: Optional additional headers to include in the request.
    /// - Returns: A decoded response of type `R`.
    /// - Throws: An `ExercismClientError` if encoding, network, or decoding fails.
    func patch<T: Encodable, R: Decodable>(to url: URL, body: T, headers: Network.HTTPHeaders?) async throws(ExercismClientError) -> R

    /// Performs an HTTP DELETE request with a request body.
    /// - Parameters:
    ///   - url: The URL to send the request to.
    ///   - body: The request body, encoded as JSON.
    ///   - headers: Optional additional headers to include in the request.
    /// - Returns: A decoded response of type `R`.
    /// - Throws: An `ExercismClientError` if encoding, network, or decoding fails.
    func delete<T: Encodable, R: Decodable>(from url: URL, body: T, headers: Network.HTTPHeaders?) async throws(ExercismClientError) -> R

    /// Downloads a file from a given URL and saves it to a specified destination.
    /// - Parameters:
    ///   - sourcePath: The URL of the file to download.
    ///   - destPath: The local file URL where the downloaded file should be saved.
    ///   - headers: Optional additional headers to include in the request.
    /// - Returns: The local file URL where the file was saved.
    /// - Throws: An `ExercismClientError` if the download or file operation fails.
    func download(from sourcePath: URL, to destPath: URL, headers: Network.HTTPHeaders?) async throws(ExercismClientError) -> URL
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
    
    /// Performs an HTTP GET request to the specified URL and decodes the response.
    ///
    /// This method:
    /// - Constructs a GET request with optional custom headers.
    /// - Sends the request asynchronously using `URLSession`.
    /// - Validates the response and decodes it into the specified type `R`.
    ///
    /// - Parameters:
    ///   - url: The target URL for the GET request.
    ///   - headers: Optional headers to include in the request.
    /// - Returns: A decoded response of type `R`.
    /// - Throws: An `ExercismClientError` if the request fails or decoding fails.
    func get<R: Decodable>(from url: URL,
                           headers: Network.HTTPHeaders? = nil) async throws(ExercismClientError) -> R {
        let request = buildRequest(method: .GET, url: url, headers: headers)
        return try await executeRequest(request: request)
    }
    
    /// Performs an HTTP POST request with a JSON-encoded request body and decodes the response.
    ///
    /// This method:
    /// - Constructs a POST request with optional headers and an encoded body.
    /// - Sends the request asynchronously using `URLSession`.
    /// - Validates the response and decodes it into the specified type `R`.
    ///
    /// - Parameters:
    ///   - url: The target URL for the POST request.
    ///   - body: A value conforming to `Encodable` to be sent as the request body.
    ///   - headers: Optional headers to include in the request.
    /// - Returns: A decoded response of type `R`.
    /// - Throws: An `ExercismClientError` if encoding, network, or decoding fails.
    func post<T: Encodable, R: Decodable>(to url: URL,
                                          body: T,
                                          headers: Network.HTTPHeaders? = nil) async throws(ExercismClientError) -> R {
        var request = buildRequest(method: .POST, url: url, headers: headers)
        let requestBody: Data
        
        do {
            requestBody = try encoder.encode(body)
        } catch {
            throw NetworkClientHelpers.extractError(error: error)
        }
        DebugEnvironment.log.trace("BODY:\n " + String(data: requestBody, encoding: .utf8)!)
        request.httpBody = requestBody
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return try await executeRequest(request: request)
    }
    
    /// Performs an HTTP PATCH request with a JSON-encoded request body and decodes the response.
    ///
    /// This method:
    /// - Constructs a PATCH request with optional headers and an encoded body.
    /// - Sends the request asynchronously using `URLSession`.
    /// - Validates the response and decodes it into the specified type `R`.
    ///
    /// - Parameters:
    ///   - url: The target URL for the PATCH request.
    ///   - body: A value conforming to `Encodable` to be sent as the request body.
    ///   - headers: Optional headers to include in the request.
    /// - Returns: A decoded response of type `R`.
    /// - Throws: An `ExercismClientError` if encoding, network, or decoding fails.
    func patch<T: Encodable, R: Decodable>(to url: URL,
                                           body: T,
                                           headers: Network.HTTPHeaders? = nil) async throws(ExercismClientError) -> R {
        var request = buildRequest(method: .PATCH, url: url, headers: headers)
        let requestBody: Data

        do {
            requestBody = try encoder.encode(body)
        } catch {
            throw NetworkClientHelpers.extractError(error: error)
        }
        
        DebugEnvironment.log.trace("BODY:\n " + String(data: requestBody, encoding: .utf8)!)
        
        request.httpBody = requestBody
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return try await executeRequest(request: request)
    }

    /// Performs an HTTP DELETE request with a JSON-encoded request body and decodes the response.
    ///
    /// This method:
    /// - Constructs a DELETE request with the given URL, headers, and encoded body.
    /// - Sends the request asynchronously using `URLSession`.
    /// - Validates the response status code.
    /// - Attempts to decode the response into the expected type `R`.
    /// - Throws a mapped `ExercismClientError` on failure.
    ///
    /// - Parameters:
    ///   - url: The endpoint to send the DELETE request to.
    ///   - body: A value conforming to `Encodable` to be used as the request body.
    ///   - headers: Optional headers to include in the request.
    /// - Returns: A decoded response of type `R`.
    /// - Throws: An `ExercismClientError` if encoding, network, or decoding fails.
    func delete<R: Decodable, T: Encodable>(
        from url: URL,
        body: T,
        headers: Network.HTTPHeaders? = nil) async throws(ExercismClientError) -> R {
        var request = buildRequest(method: .DELETE, url: url, headers: headers)
        let requestBody: Data

        do {
            requestBody = try encoder.encode(body)
        } catch {
            throw NetworkClientHelpers.extractError(error: error)
        }

        DebugEnvironment.log.trace("BODY:\n " + (String(data: requestBody, encoding: .utf8) ?? ""))
        request.httpBody = requestBody
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        return try await executeRequest(request: request)
    }


    /// Downloads a file from the specified URL and saves it to the given destination path.
    ///
    /// This method:
    /// - Constructs a GET request to download a file.
    /// - Validates that the response status code is within the 2xx range.
    /// - Saves the downloaded file to the destination URL, replacing it if it already exists.
    /// - Returns the destination URL if successful.
    /// - Throws a mapped `ExercismClientError` if the request or file operation fails.
    ///
    /// - Parameters:
    ///   - sourcePath: The URL from which to download the file.
    ///   - destPath: The local destination URL to save the downloaded file.
    ///   - headers: Optional headers to include in the request.
    /// - Returns: The `URL` of the saved file.
    /// - Throws: An `ExercismClientError` if the download or file handling fails.
    func download(from sourcePath: URL,
                  to destPath: URL,
                  headers: Network.HTTPHeaders? = [:]) async throws(ExercismClientError) -> URL {
        let request = initRequest(url: sourcePath, headers: headers)

        do {
            let (tempURL, response) = try await URLSession.shared.download(for: request)
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                throw NetworkClientHelpers.extractError(data: nil, response: response)
            }

            DebugEnvironment.log.trace("Downloaded file location: \(tempURL.description)")

            if FileManager.default.fileExists(atPath: destPath.relativePath) {
                _ = try FileManager.default.replaceItemAt(destPath, withItemAt: tempURL)
            } else {
                _ = try FileManager.default.moveItem(at: tempURL, to: destPath)
            }
            return destPath
        } catch {
            throw NetworkClientHelpers.extractError(error: error)

        }
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
    
    /// Executes a network request asynchronously, validates the response, and decodes it into the specified type.
    ///
    /// This method performs the following steps:
    /// - Sends an HTTP request using `URLSession.shared.data(for:)`.
    /// - Verifies that the HTTP response has a 2xx status code.
    /// - If the response indicates an error (non-2xx status), it uses `NetworkClientHelpers.extractError(data:response:)` to extract a meaningful `ExercismClientError`.
    /// - Attempts to decode the received data into the specified `Decodable` type `T`.
    /// - If decoding fails, it maps the thrown error using `NetworkClientHelpers.extractError(error:)`.
    ///
    /// - Parameters:
    ///   - request: The `URLRequest` to be executed.
    /// - Returns: A decoded object of type `T`.
    /// - Throws: An `ExercismClientError` if the request fails, the response is invalid, or decoding fails.
    private func executeRequest<T: Decodable>(request: URLRequest) async throws(ExercismClientError) -> T {
        DebugEnvironment.log.debug("Request: \(request.httpMethod ?? "") \(request.url?.absoluteString ?? "")")

        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                throw NetworkClientHelpers.extractError(data: data, response: response)
            }
            DebugEnvironment.log.trace(String(data: data, encoding: .utf8) ?? "")
            let result = try self.decoder.decode(T.self, from: data)
            return result
        } catch {
            throw NetworkClientHelpers.extractError(error: error)
        }
    }
}
