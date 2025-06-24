import Foundation

/// A client for interacting with the Exercism API.
/// Handles network requests and authentication using an API token.
public final class ExercismClient: ExercismClientType {
    /// The API token used for authentication.
    private var apiToken: String? = nil
    
    /// The network client responsible for making API requests.
    let networkClient: NetworkClient
    
    /// The URL builder used to construct API request URLs.
    let urlBuilder = URLBuilder()

    var headers: Network.HTTPHeaders = [:]

    /// Initializes the client with an API token and an optional network client.
    /// - Parameters:
    ///   - apiToken: The API token for authentication.
    ///   - networkClient: An optional network client. If `nil`, a `DefaultNetworkClient` is used.
    public init(apiToken: String,
                networkClient: NetworkClient? = nil) {
        self.apiToken = apiToken
        self.networkClient = networkClient ?? DefaultNetworkClient(apiToken)
    }
    
    /// Initializes the client with an optional network client.
    /// - Parameter networkClient: An optional network client. If `nil`, a `DefaultNetworkClient` is used.
    public init(networkClient: NetworkClient? = nil) {
        self.networkClient = networkClient ?? DefaultNetworkClient(apiToken)
    }
}
