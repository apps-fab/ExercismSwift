import Foundation

public final class ExercismClient: ExercismClientType {
    private var apiToken: String? = nil
    let networkClient: NetworkClient

    private let userAgent = "Exercism macOS"
    let urlBuilder = URLBuilder()

    public init(
            apiToken: String,
            networkClient: NetworkClient? = nil
    ) {
        self.apiToken = apiToken
        self.networkClient = networkClient ?? DefaultNetworkClient(apiToken)
    }

    public init(
            networkClient: NetworkClient? = nil
    ) {
        self.networkClient = networkClient ?? DefaultNetworkClient(apiToken)
    }

    func headers() -> Network.HTTPHeaders {
        [:]
    }
}
