import API
import Foundation

public struct World {
    public init(urlSession: URLSessionProtocol, jsonDecoder: JSONDecoder) {
        self.urlSession = urlSession
        self.jsonDecoder = jsonDecoder
    }

    public let urlSession: URLSessionProtocol
    public let jsonDecoder: JSONDecoder
}
