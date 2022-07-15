import Foundation

public final class ExercismClient: ExercismClientType {
    private var apiToken: String? = nil
    let networkClient: NetworkClient

    private let userAgent = "Exercism macOS"
    let urlBuilder = URLBuilder()

    public init(
            apiToken: String,
            networkClient: NetworkClient = DefaultNetworkClient()
    ) {
        self.apiToken = apiToken
        self.networkClient = networkClient
    }

    public init(
            networkClient: NetworkClient = DefaultNetworkClient()
    ) {
        self.networkClient = networkClient
    }

    func headers() -> Network.HTTPHeaders {
        var headers = [
            "User-Agent": userAgent,
        ]
        if let apiToken = apiToken {
            headers["Authorization"] = "Bearer \(apiToken)"
        }

        return headers
    }
}
